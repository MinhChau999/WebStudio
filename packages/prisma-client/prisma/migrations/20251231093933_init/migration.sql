CREATE TYPE "UploadStatus" AS ENUM ('UPLOADING', 'UPLOADED');
CREATE TYPE "DomainStatus" AS ENUM ('INITIALIZING', 'ACTIVE', 'ERROR', 'PENDING');

CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "File" (
    "name" TEXT NOT NULL,
    "format" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "meta" TEXT NOT NULL DEFAULT '{}',
    "status" "UploadStatus" NOT NULL DEFAULT 'UPLOADING',
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "uploaderProjectId" TEXT,
    CONSTRAINT "File_pkey" PRIMARY KEY ("name")
);

CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "filename" TEXT,
    "description" TEXT,
    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id","projectId")
);

CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "provider" TEXT,
    "image" TEXT,
    "username" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "teamId" TEXT,
    "projectsTags" JSONB NOT NULL DEFAULT '[]',
    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL,
    "domain" TEXT NOT NULL,
    "tags" TEXT[],
    "userId" TEXT,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "previewImageAssetId" TEXT,
    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Build" (
    "id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "lastTransactionId" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pages" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "breakpoints" TEXT NOT NULL DEFAULT '[]',
    "styles" TEXT NOT NULL DEFAULT '[]',
    "styleSources" TEXT NOT NULL DEFAULT '[]',
    "styleSourceSelections" TEXT NOT NULL DEFAULT '[]',
    "props" TEXT NOT NULL DEFAULT '[]',
    "dataSources" TEXT NOT NULL DEFAULT '[]',
    "resources" TEXT NOT NULL DEFAULT '[]',
    "instances" TEXT NOT NULL DEFAULT '[]',
    CONSTRAINT "Build_pkey" PRIMARY KEY ("id","projectId")
);

CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "meta" JSONB NOT NULL DEFAULT '{}',
    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "UserProduct" (
    "userId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "subscriptionId" TEXT,
    "customerId" TEXT,
    "customerEmail" TEXT
);

CREATE TABLE "Domain" (
    "id" TEXT NOT NULL,
    "domain" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "txtRecord" TEXT,
    "status" "DomainStatus" NOT NULL DEFAULT 'INITIALIZING',
    "error" TEXT,
    CONSTRAINT "Domain_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "ProjectDomain" (
    "projectId" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "txtRecord" TEXT NOT NULL,
    "cname" TEXT NOT NULL,
    CONSTRAINT "ProjectDomain_pkey" PRIMARY KEY ("projectId","domainId")
);

CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "Project_domain_key" ON "Project"("domain");
CREATE UNIQUE INDEX "Project_id_isDeleted_key" ON "Project"("id", "isDeleted");
CREATE UNIQUE INDEX "Build_id_key" ON "Build"("id");
CREATE INDEX "Build_projectId_createdAt_idx" ON "Build"("projectId", "createdAt" DESC);
CREATE UNIQUE INDEX "UserProduct_userId_productId_key" ON "UserProduct"("userId", "productId");
CREATE UNIQUE INDEX "Domain_domain_key" ON "Domain"("domain");
CREATE UNIQUE INDEX "ProjectDomain_txtRecord_key" ON "ProjectDomain"("txtRecord");
CREATE INDEX "ProjectDomain_domainId_idx" ON "ProjectDomain"("domainId");

ALTER TABLE "File" ADD CONSTRAINT "File_uploaderProjectId_fkey" FOREIGN KEY ("uploaderProjectId") REFERENCES "Project"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_name_fkey" FOREIGN KEY ("name") REFERENCES "File"("name") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "User" ADD CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Project" ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Project" ADD CONSTRAINT "Project_previewImageAssetId_id_fkey" FOREIGN KEY ("previewImageAssetId", "id") REFERENCES "Asset"("id", "projectId") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "Build" ADD CONSTRAINT "Build_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "UserProduct" ADD CONSTRAINT "UserProduct_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "UserProduct" ADD CONSTRAINT "UserProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ProjectDomain" ADD CONSTRAINT "ProjectDomain_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ProjectDomain" ADD CONSTRAINT "ProjectDomain_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

DROP VIEW IF EXISTS "DashboardProject";
CREATE VIEW "DashboardProject" AS
SELECT
  id,
  title,
  tags,
  "userId",
  "domain",
  "isDeleted",
  "createdAt",
  "previewImageAssetId"
FROM
  "Project";

CREATE TYPE "PublishStatus" AS ENUM ('PENDING', 'PUBLISHED', 'FAILED');

ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "deployment" JSONB;
ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "publishStatus" "PublishStatus" NOT NULL DEFAULT 'PENDING';
ALTER TABLE "Build" ADD COLUMN IF NOT EXISTS "isCleaned" BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS "domainsVirtual" (
    "id" text PRIMARY KEY NOT NULL,
    "domainId" text NOT NULL,
    "projectId" text NOT NULL,
    "domain" text NOT NULL,
    "status" "DomainStatus" NOT NULL DEFAULT 'INITIALIZING'::"DomainStatus",
    "error" text,
    "domainTxtRecord" text,
    "expectedTxtRecord" text NOT NULL,
    "cname" text NOT NULL,
    "verified" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp(3) with time zone NOT NULL,
    "updatedAt" timestamp(3) with time zone NOT NULL,
    CONSTRAINT "domainsVirtual_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "domainsVirtual_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "latestBuildVirtual" (
    "buildId" text NOT NULL,
    "projectId" text NOT NULL,
    "domainsVirtualId" text,
    "domain" text NOT NULL,
    "createdAt" timestamp(3) with time zone NOT NULL,
    "updatedAt" timestamp(3) with time zone NOT NULL DEFAULT NOW(),
    "publishStatus" TEXT NOT NULL,
    CONSTRAINT "latestBuildVirtual_buildId_fkey" FOREIGN KEY ("buildId") REFERENCES "Build"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "latestBuildVirtual_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "latestBuildVirtual_domainsVirtualId_fkey" FOREIGN KEY ("domainsVirtualId") REFERENCES "domainsVirtual"("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "latestBuildVirtual_pkey" PRIMARY KEY ("projectId")
);

CREATE UNIQUE INDEX IF NOT EXISTS "latestBuildVirtual_buildId_key" ON "latestBuildVirtual"("buildId");

CREATE OR REPLACE VIEW "LatestStaticBuildPerProject" AS
SELECT
    b.id AS "buildId",
    b."projectId",
    b."publishStatus",
    b."updatedAt"
FROM "Build" b
INNER JOIN (
    SELECT "projectId", MAX("createdAt") AS "maxCreatedAt"
    FROM "Build"
    WHERE deployment IS NOT NULL
    GROUP BY "projectId"
) latest ON b."projectId" = latest."projectId" AND b."createdAt" = latest."maxCreatedAt"
WHERE b.deployment IS NOT NULL;

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
      AND (
          (b.deployment::jsonb ->> 'projectDomain') = $1.domain
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1.domain])
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[d.domain])
      )
    ORDER BY b."createdAt" DESC
    LIMIT 1;
$$ STABLE LANGUAGE sql;

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
      AND (
          (b.deployment::jsonb ->> 'projectDomain') = $1.domain
          OR (b.deployment::jsonb -> 'domains') @> to_jsonb(array[$1.domain])
      )
    ORDER BY b."createdAt" DESC
    LIMIT 1;
$$ STABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "latestBuildVirtual"("DashboardProject")
RETURNS SETOF "latestBuildVirtual" ROWS 1 AS $$
    SELECT * FROM "latestBuildVirtual"((SELECT p FROM "Project" p WHERE p.id = $1.id));
$$ STABLE LANGUAGE sql;

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

COMMENT ON TYPE "PublishStatus" IS 'Build publish status: PENDING, PUBLISHED, or FAILED';
COMMENT ON TABLE "domainsVirtual" IS 'Virtual table representing domains related to each project. Used for PostgREST types.';
COMMENT ON TABLE "latestBuildVirtual" IS 'Virtual table representing the latest build for each project. Used for PostgREST types.';
COMMENT ON FUNCTION "latestBuildVirtual"("Project") IS 'Computes the latest build for a project.';
COMMENT ON FUNCTION "latestBuildVirtual"("domainsVirtual") IS 'Returns the latest build for a given project and domain.';
COMMENT ON FUNCTION "latestBuildVirtual"("DashboardProject") IS 'Wrapper to make latestBuildVirtual work with DashboardProject view.';

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
