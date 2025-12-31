-- Consolidation and Optimization of Virtual Tables and Functions for PostgREST

-- 1. Create PublishStatus enum first (needed by latestBuildVirtual table)
CREATE TYPE "PublishStatus" AS ENUM ('PENDING', 'PUBLISHED', 'FAILED');

-- 2. Add missing columns to Build table (dependency for functions)
ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "deployment" JSONB;
ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "publishStatus" TEXT DEFAULT 'PENDING';
ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "isCleaned" BOOLEAN DEFAULT FALSE;

-- 3. Create virtual tables for PostgREST computed relationships
CREATE TABLE IF NOT EXISTS "domainsVirtual" (
    "id" text PRIMARY KEY NOT NULL,
    "domainId" text REFERENCES "Domain" (id) NOT NULL,
    "projectId" text REFERENCES "Project" (id) NOT NULL,
    "domain" text NOT NULL,
    "status" "DomainStatus" NOT NULL DEFAULT 'INITIALIZING'::"DomainStatus",
    "error" text,
    "domainTxtRecord" text,
    "expectedTxtRecord" text NOT NULL,
    "cname" text NOT NULL,
    "verified" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp(3) with time zone NOT NULL,
    "updatedAt" timestamp(3) with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS "latestBuildVirtual" (
    "buildId" text REFERENCES "Build" (id) UNIQUE NOT NULL,
    "projectId" text PRIMARY KEY REFERENCES "Project" (id) NOT NULL,
    "domainsVirtualId" text REFERENCES "domainsVirtual" ("id"),
    "domain" text NOT NULL,
    "createdAt" timestamp(3) with time zone NOT NULL,
    "updatedAt" timestamp(3) with time zone NOT NULL DEFAULT NOW(),
    "publishStatus" TEXT NOT NULL  -- Use TEXT instead of PublishStatus enum to match Build table
);

-- 4. CREATE Functions

-- Function for domainsVirtual
CREATE OR REPLACE FUNCTION "domainsVirtual"("Project")
RETURNS SETOF "domainsVirtual" AS $$
    SELECT
        d.id || '-' || pd."projectId" as id,
        d.id AS "domainId",
        pd."projectId",
        d.domain,
        d.status,
        d.error,
        d."txtRecord" AS "domainTxtRecord",
        pd."txtRecord" AS "expectedTxtRecord",
        pd."cname" AS "cname",
        (d."txtRecord" = pd."txtRecord") AS "verified",
        pd."createdAt",
        d."updatedAt"
    FROM "Domain" d
    JOIN "ProjectDomain" pd ON d.id = pd."domainId"
    WHERE pd."projectId" = $1.id
    ORDER BY pd."createdAt" ASC, d.id ASC;
$$ STABLE LANGUAGE sql;

-- Helper to check if a build matches certain conditions
CREATE OR REPLACE FUNCTION "is_saas_production_build"("Build")
RETURNS boolean AS $$
    SELECT $1.deployment IS NOT NULL
      AND (($1.deployment::jsonb ->> 'destination') IS NULL
           OR ($1.deployment::jsonb ->> 'destination') = 'saas');
$$ STABLE LANGUAGE sql;

-- latestBuildVirtual for Project
CREATE OR REPLACE FUNCTION "latestBuildVirtual"("Project")
RETURNS SETOF "latestBuildVirtual" ROWS 1 AS $$
    SELECT
        b.id AS "buildId",
        b."projectId",
        '' AS "domainsVirtualId",
        CASE
            WHEN (b.deployment::jsonb ->> 'projectDomain') = $1.domain
                 OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1.domain])
            THEN $1.domain
            ELSE COALESCE(d.domain, $1.domain)
        END AS "domain",
        b."createdAt",
        b."updatedAt",
        b."publishStatus"
    FROM "Build" b
    LEFT JOIN "ProjectDomain" pd ON pd."projectId" = b."projectId"
    LEFT JOIN "Domain" d ON d.id = pd."domainId"
    WHERE b."projectId" = $1.id
      AND "is_saas_production_build"(b)
      AND (
          (b.deployment::jsonb ->> 'projectDomain') = $1.domain
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1.domain])
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[d.domain])
      )
    ORDER BY b."createdAt" DESC
    LIMIT 1;
$$ STABLE LANGUAGE sql;

-- latestBuildVirtual for domainsVirtual
CREATE OR REPLACE FUNCTION "latestBuildVirtual"("domainsVirtual")
RETURNS SETOF "latestBuildVirtual" ROWS 1 AS $$
    SELECT
        b.id AS "buildId",
        b."projectId",
        '' AS "domainsVirtualId",
        $1."domain" AS "domain",
        b."createdAt",
        b."updatedAt",
        b."publishStatus"
    FROM "Build" b
    WHERE b."projectId" = $1."projectId"
      AND b.deployment IS NOT NULL
      AND (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1."domain"])
    ORDER BY b."createdAt" DESC
    LIMIT 1;
$$ STABLE LANGUAGE sql;

-- latestProjectDomainBuildVirtual
CREATE OR REPLACE FUNCTION "latestProjectDomainBuildVirtual"("Project")
RETURNS SETOF "latestBuildVirtual" ROWS 1 AS $$
    SELECT
        b.id AS "buildId",
        b."projectId",
        '' AS "domainsVirtualId",
        $1.domain AS "domain",
        b."createdAt",
        b."updatedAt",
        b."publishStatus"
    FROM "Build" b
    WHERE b."projectId" = $1.id
      AND "is_saas_production_build"(b)
      AND (
          (b.deployment::jsonb ->> 'projectDomain') = $1.domain
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1.domain])
      )
    ORDER BY b."createdAt" DESC
    LIMIT 1;
$$ STABLE LANGUAGE sql;

-- latestBuildVirtual for DashboardProject (wrapper that delegates to Project function)
CREATE OR REPLACE FUNCTION "latestBuildVirtual"("DashboardProject")
RETURNS SETOF "latestBuildVirtual" ROWS 1 AS $$
    SELECT * FROM "latestBuildVirtual"((SELECT p FROM "Project" p WHERE p.id = $1.id));
$$ STABLE LANGUAGE sql;

-- 5. Database Cleanup Function
CREATE OR REPLACE FUNCTION database_cleanup(
  from_date timestamp DEFAULT '2020-01-01 00:00:00',
  to_date timestamp DEFAULT '2099-12-31 23:59:59'
) RETURNS VOID AS $$
BEGIN
  WITH latest_builds AS (
    SELECT "buildId" FROM "Project" p, LATERAL "latestProjectDomainBuildVirtual"(p)
    UNION
    SELECT "buildId" FROM "Project" p, LATERAL "latestBuildVirtual"(p)
    UNION
    SELECT lb."buildId"
    FROM "Project" p, LATERAL "domainsVirtual"(p) dv, LATERAL "latestBuildVirtual"(dv) lb
  )
  UPDATE "Build"
  SET
    "styleSources" = '[]'::text,
    styles = '[]'::text,
    breakpoints = '[]'::text,
    "styleSourceSelections" = '[]'::text,
    props = '[]'::text,
    instances = '[]'::text,
    "dataSources" = '[]'::text,
    resources = '[]'::text,
    "marketplaceProduct" = '{}'::text,
    "isCleaned" = TRUE
  WHERE deployment IS NOT NULL
  AND id NOT IN (SELECT "buildId" FROM latest_builds)
  AND (NOT "isCleaned")
  AND "createdAt" BETWEEN from_date AND to_date;
END;
$$ LANGUAGE plpgsql;

-- 6. Comments and Permissions
COMMENT ON TYPE "PublishStatus" IS 'Build publish status: PENDING, PUBLISHED, or FAILED';
COMMENT ON TABLE "domainsVirtual" IS 'Virtual table representing domains related to each project. Used for PostgREST types.';
COMMENT ON TABLE "latestBuildVirtual" IS 'Virtual table representing the latest build for each project. Used for PostgREST types.';
COMMENT ON FUNCTION "latestBuildVirtual"("Project") IS 'Computes the latest build for a project.';
COMMENT ON FUNCTION "latestBuildVirtual"("domainsVirtual") IS 'Returns the latest build for a given project and domain.';
COMMENT ON FUNCTION "latestBuildVirtual"("DashboardProject") IS 'Wrapper to make latestBuildVirtual work with DashboardProject view.';
COMMENT ON FUNCTION "is_saas_production_build"("Build") IS 'Helper function to check if a build is a SaaS production build.';

DO $$
DECLARE
  role_name TEXT;
BEGIN
  FOREACH role_name IN ARRAY ARRAY['anon', 'authenticated', 'service_role']
  LOOP
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role_name) THEN
      EXECUTE format('GRANT EXECUTE ON FUNCTION "latestBuildVirtual"("DashboardProject") TO %I', role_name);
      EXECUTE format('GRANT EXECUTE ON FUNCTION "latestBuildVirtual"("Project") TO %I', role_name);
      EXECUTE format('GRANT EXECUTE ON FUNCTION "latestBuildVirtual"("domainsVirtual") TO %I', role_name);
      EXECUTE format('GRANT EXECUTE ON FUNCTION "latestProjectDomainBuildVirtual"("Project") TO %I', role_name);
      EXECUTE format('GRANT EXECUTE ON FUNCTION "domainsVirtual"("Project") TO %I', role_name);
    END IF;
  END LOOP;
END $$;
