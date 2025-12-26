import { router } from "@webstudio-is/trpc-interface/index.server";
import { projectRouter } from "@webstudio-is/project/index.server";
import { dashboardProjectRouter } from "@webstudio-is/dashboard/index.server";

/**
 * Simplified tRPC router - no authentication, marketplace, or domain
 */
export const appRouter = router({
  // domain: domainRouter, // Removed for simplified local setup
  project: projectRouter,
  dashboardProject: dashboardProjectRouter,
});

export type AppRouter = typeof appRouter;
