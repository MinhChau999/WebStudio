-- CreateView for LatestStaticBuildPerProject
CREATE OR REPLACE VIEW "LatestStaticBuildPerProject" AS
SELECT
    "Build"."id" AS "buildId",
    "Build"."projectId",
    "Build"
FROM "Build"
WHERE ("Build"."version", "Build"."projectId", "Build"."createdAt") IN (
    SELECT MAX("Build1"."version"), "Build1"."projectId", "Build1"."createdAt"
    FROM "Build" "Build1"
    GROUP BY "Build1"."projectId"
);

-- CreateView for DashboardProject
CREATE OR REPLACE VIEW "DashboardProject" AS
SELECT
    "Project"."id",
    "Project"."createdAt",
    "Project"."title",
    "Project"."userId",
    "Project"."id" AS "projectId",
    "Project"."previewImageAssetId",
    "Project"."isDeleted"
FROM "Project"
WHERE "Project"."isDeleted" = false;
