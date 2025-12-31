# Prisma Client for MySQL

This is a MySQL-compatible version of the `@webstudio-is/prisma-client` package.

## Differences from PostgreSQL version

1. **Database Provider**: `mysql` instead of `postgres`
2. **Timestamp Type**: `@db.Timestamp(3)` instead of `@db.Timestamptz(3)`
   - MySQL doesn't have timezone-aware timestamps
   - All timestamps are stored in UTC

## Database URL Format

```bash
# MySQL connection string
DATABASE_URL="mysql://user:password@localhost:3306/database"
```

## Usage

```typescript
import { PrismaClient } from "@webstudio-is/prisma-client-mysql";

const prisma = new PrismaClient();

// Same API as PostgreSQL version
const projects = await prisma.project.findMany();
```

## Migrations

```bash
# Generate Prisma Client
pnpm --filter=@webstudio-is/prisma-client-mysql generate

# Run migrations
pnpm --filter=@webstudio-is/prisma-client-mysql migrations
```

## Environment Variables

```bash
# Required
DATABASE_URL="mysql://user:password@localhost:3306/webstudio"
DIRECT_URL="mysql://user:password@localhost:3306/webstudio"
```
