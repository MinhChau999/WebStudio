-- DropForeignKey
ALTER TABLE `book_deposit` DROP FOREIGN KEY `FK_book_deposit_book_id`;

-- DropForeignKey
ALTER TABLE `book_deposit` DROP FOREIGN KEY `FK_book_deposit_deposit_id`;

-- DropTable
DROP TABLE `annotations`;

-- DropTable
DROP TABLE `approval_logs`;

-- DropTable
DROP TABLE `approval_stages`;

-- DropTable
DROP TABLE `author`;

-- DropTable
DROP TABLE `book`;

-- DropTable
DROP TABLE `book_attachment`;

-- DropTable
DROP TABLE `book_author`;

-- DropTable
DROP TABLE `book_cate`;

-- DropTable
DROP TABLE `book_classes`;

-- DropTable
DROP TABLE `book_deposit`;

-- DropTable
DROP TABLE `book_issue`;

-- DropTable
DROP TABLE `book_metadata`;

-- DropTable
DROP TABLE `book_outline`;

-- DropTable
DROP TABLE `book_register`;

-- DropTable
DROP TABLE `book_style`;

-- DropTable
DROP TABLE `book_user`;

-- DropTable
DROP TABLE `cate`;

-- DropTable
DROP TABLE `chap`;

-- DropTable
DROP TABLE `chap_save`;

-- DropTable
DROP TABLE `chapter_comments`;

-- DropTable
DROP TABLE `chapter_content_logs`;

-- DropTable
DROP TABLE `checkdata`;

-- DropTable
DROP TABLE `comment`;

-- DropTable
DROP TABLE `config`;

-- DropTable
DROP TABLE `content`;

-- DropTable
DROP TABLE `contracts`;

-- DropTable
DROP TABLE `deposit`;

-- DropTable
DROP TABLE `grapes_blocks`;

-- DropTable
DROP TABLE `group_user`;

-- DropTable
DROP TABLE `groups`;

-- DropTable
DROP TABLE `log`;

-- DropTable
DROP TABLE `medias`;

-- DropTable
DROP TABLE `notes`;

-- DropTable
DROP TABLE `notifications`;

-- DropTable
DROP TABLE `options`;

-- DropTable
DROP TABLE `partner`;

-- DropTable
DROP TABLE `pdf`;

-- DropTable
DROP TABLE `pdf_signatures`;

-- DropTable
DROP TABLE `prompts`;

-- DropTable
DROP TABLE `push_subscriptions`;

-- DropTable
DROP TABLE `resources`;

-- DropTable
DROP TABLE `roles`;

-- DropTable
DROP TABLE `story`;

-- DropTable
DROP TABLE `story_author`;

-- DropTable
DROP TABLE `story_cate`;

-- DropTable
DROP TABLE `story_submissions`;

-- DropTable
DROP TABLE `story_tag`;

-- DropTable
DROP TABLE `sys_log`;

-- DropTable
DROP TABLE `tag`;

-- DropTable
DROP TABLE `user`;

-- DropTable
DROP TABLE `user_group`;

-- DropTable
DROP TABLE `usergroup`;

-- DropTable
DROP TABLE `workflow_actions`;

-- DropTable
DROP TABLE `workflow_assignments`;

-- DropTable
DROP TABLE `workflow_instances`;

-- DropTable
DROP TABLE `workflow_step_user`;

-- DropTable
DROP TABLE `workflow_steps`;

-- DropTable
DROP TABLE `workflows`;

-- CreateTable
CREATE TABLE `Team` (
    `id` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `File` (
    `name` VARCHAR(191) NOT NULL,
    `format` VARCHAR(191) NOT NULL,
    `size` INTEGER NOT NULL,
    `description` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `meta` VARCHAR(191) NOT NULL DEFAULT '{}',
    `status` ENUM('UPLOADING', 'UPLOADED') NOT NULL DEFAULT 'UPLOADING',
    `isDeleted` BOOLEAN NOT NULL DEFAULT false,
    `uploaderProjectId` VARCHAR(191) NULL,

    PRIMARY KEY (`name`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Asset` (
    `id` VARCHAR(191) NOT NULL,
    `projectId` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `filename` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,

    PRIMARY KEY (`id`, `projectId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User` (
    `id` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NULL,
    `provider` VARCHAR(191) NULL,
    `image` VARCHAR(191) NULL,
    `username` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `teamId` VARCHAR(191) NULL,
    `projectsTags` JSON NOT NULL,

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Project` (
    `id` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `title` VARCHAR(191) NOT NULL,
    `domain` VARCHAR(191) NOT NULL,
    `tags` JSON NOT NULL,
    `userId` VARCHAR(191) NULL,
    `isDeleted` BOOLEAN NOT NULL DEFAULT false,
    `previewImageAssetId` VARCHAR(191) NULL,

    UNIQUE INDEX `Project_domain_key`(`domain`),
    UNIQUE INDEX `Project_id_isDeleted_key`(`id`, `isDeleted`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Build` (
    `id` VARCHAR(191) NOT NULL,
    `version` INTEGER NOT NULL DEFAULT 0,
    `lastTransactionId` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `pages` VARCHAR(191) NOT NULL,
    `projectId` VARCHAR(191) NOT NULL,
    `breakpoints` VARCHAR(191) NOT NULL DEFAULT '[]',
    `styles` VARCHAR(191) NOT NULL DEFAULT '[]',
    `styleSources` VARCHAR(191) NOT NULL DEFAULT '[]',
    `styleSourceSelections` VARCHAR(191) NOT NULL DEFAULT '[]',
    `props` VARCHAR(191) NOT NULL DEFAULT '[]',
    `dataSources` VARCHAR(191) NOT NULL DEFAULT '[]',
    `resources` VARCHAR(191) NOT NULL DEFAULT '[]',
    `instances` VARCHAR(191) NOT NULL DEFAULT '[]',
    `deployment` JSON NULL,
    `publishStatus` ENUM('PENDING', 'PUBLISHED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    `isCleaned` BOOLEAN NOT NULL DEFAULT false,

    UNIQUE INDEX `Build_id_key`(`id`),
    INDEX `Build_projectId_createdAt_idx`(`projectId`, `createdAt` DESC),
    PRIMARY KEY (`id`, `projectId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Product` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `meta` JSON NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `UserProduct` (
    `userId` VARCHAR(191) NOT NULL,
    `productId` VARCHAR(191) NOT NULL,
    `subscriptionId` VARCHAR(191) NULL,
    `customerId` VARCHAR(191) NULL,
    `customerEmail` VARCHAR(191) NULL,

    UNIQUE INDEX `UserProduct_userId_productId_key`(`userId`, `productId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Domain` (
    `id` VARCHAR(191) NOT NULL,
    `domain` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `txtRecord` VARCHAR(191) NULL,
    `status` ENUM('INITIALIZING', 'ACTIVE', 'ERROR', 'PENDING') NOT NULL DEFAULT 'INITIALIZING',
    `error` VARCHAR(191) NULL,

    UNIQUE INDEX `Domain_domain_key`(`domain`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ProjectDomain` (
    `projectId` VARCHAR(191) NOT NULL,
    `domainId` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `txtRecord` VARCHAR(191) NOT NULL,
    `cname` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `ProjectDomain_txtRecord_key`(`txtRecord`),
    INDEX `ProjectDomain_domainId_idx`(`domainId`),
    PRIMARY KEY (`projectId`, `domainId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `File` ADD CONSTRAINT `File_uploaderProjectId_fkey` FOREIGN KEY (`uploaderProjectId`) REFERENCES `Project`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Asset` ADD CONSTRAINT `Asset_name_fkey` FOREIGN KEY (`name`) REFERENCES `File`(`name`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_teamId_fkey` FOREIGN KEY (`teamId`) REFERENCES `Team`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Project` ADD CONSTRAINT `Project_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Project` ADD CONSTRAINT `Project_previewImageAssetId_id_fkey` FOREIGN KEY (`previewImageAssetId`, `id`) REFERENCES `Asset`(`id`, `projectId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Build` ADD CONSTRAINT `Build_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `Project`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserProduct` ADD CONSTRAINT `UserProduct_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserProduct` ADD CONSTRAINT `UserProduct_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ProjectDomain` ADD CONSTRAINT `ProjectDomain_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `Project`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ProjectDomain` ADD CONSTRAINT `ProjectDomain_domainId_fkey` FOREIGN KEY (`domainId`) REFERENCES `Domain`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

