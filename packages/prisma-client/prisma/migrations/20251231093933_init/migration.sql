-- CreateEnum
CREATE TYPE "UploadStatus" AS ENUM ('UPLOADING', 'UPLOADED');

-- CreateEnum
CREATE TYPE "DomainStatus" AS ENUM ('INITIALIZING', 'ACTIVE', 'ERROR', 'PENDING');

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
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

-- CreateTable
CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "filename" TEXT,
    "description" TEXT,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id","projectId")
);

-- CreateTable
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

-- CreateTable
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

-- CreateTable
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

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "meta" JSONB NOT NULL DEFAULT '{}',

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserProduct" (
    "userId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "subscriptionId" TEXT,
    "customerId" TEXT,
    "customerEmail" TEXT
);

-- CreateTable
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

-- CreateTable
CREATE TABLE "ProjectDomain" (
    "projectId" TEXT NOT NULL,
    "domainId" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "txtRecord" TEXT NOT NULL,
    "cname" TEXT NOT NULL,

    CONSTRAINT "ProjectDomain_pkey" PRIMARY KEY ("projectId","domainId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Project_domain_key" ON "Project"("domain");

-- CreateIndex
CREATE UNIQUE INDEX "Project_id_isDeleted_key" ON "Project"("id", "isDeleted");

-- CreateIndex
CREATE UNIQUE INDEX "Build_id_key" ON "Build"("id");

-- CreateIndex
CREATE INDEX "Build_projectId_createdAt_idx" ON "Build"("projectId", "createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "UserProduct_userId_productId_key" ON "UserProduct"("userId", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "Domain_domain_key" ON "Domain"("domain");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectDomain_txtRecord_key" ON "ProjectDomain"("txtRecord");

-- CreateIndex
CREATE INDEX "ProjectDomain_domainId_idx" ON "ProjectDomain"("domainId");

-- AddForeignKey
ALTER TABLE "File" ADD CONSTRAINT "File_uploaderProjectId_fkey" FOREIGN KEY ("uploaderProjectId") REFERENCES "Project"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_name_fkey" FOREIGN KEY ("name") REFERENCES "File"("name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_previewImageAssetId_id_fkey" FOREIGN KEY ("previewImageAssetId", "id") REFERENCES "Asset"("id", "projectId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Build" ADD CONSTRAINT "Build_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserProduct" ADD CONSTRAINT "UserProduct_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserProduct" ADD CONSTRAINT "UserProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectDomain" ADD CONSTRAINT "ProjectDomain_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
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