-- DropForeignKey
ALTER TABLE "domainsVirtual" DROP CONSTRAINT "domainsVirtual_domainId_fkey";

-- DropForeignKey
ALTER TABLE "domainsVirtual" DROP CONSTRAINT "domainsVirtual_projectId_fkey";

-- DropForeignKey
ALTER TABLE "latestBuildVirtual" DROP CONSTRAINT "latestBuildVirtual_buildId_fkey";

-- DropForeignKey
ALTER TABLE "latestBuildVirtual" DROP CONSTRAINT "latestBuildVirtual_domainsVirtualId_fkey";

-- DropForeignKey
ALTER TABLE "latestBuildVirtual" DROP CONSTRAINT "latestBuildVirtual_projectId_fkey";

-- AlterTable
ALTER TABLE "Build" DROP COLUMN "deployment",
DROP COLUMN "isCleaned",
DROP COLUMN "publishStatus";

-- DropTable
DROP TABLE "domainsVirtual";

-- DropTable
DROP TABLE "latestBuildVirtual";

-- Create LatestStaticBuildPerProject view
-- This view represents the latest static build for each project
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