import { useEffect, useState } from "react";
import { json, type LoaderFunctionArgs } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { Dashboard } from "~/dashboard/dashboard";
import { createContext } from "~/shared/context.server";
import { createOrLoginWithDev } from "~/shared/db/user.server";
import { getUserPlanFeatures } from "~/shared/db/user-plan-features.server";
import type { DashboardData } from "~/dashboard/shared/types";
import { db } from "@webstudio-is/dashboard/index.server";
export { ErrorBoundary } from "~/shared/error/error-boundary";

/**
 * Templates route loader
 * Same logic as index but for /templates path
 */
export const loader = async (args: LoaderFunctionArgs) => {
  const { request } = args;
  const context = await createContext(request);

  // Create or get dev user for local development
  const user = await createOrLoginWithDev(context, "dev@localhost");

  // Fetch user plan features
  const userPlanFeatures = await getUserPlanFeatures(
    user.id,
    context.postgrest
  );

  // Fetch all projects (without auth filtering for simplified local setup)
  const projects = await db.db.findMany(user.id, context);

  // For templates, we'll use the same projects for now
  // In production, templates would be fetched from a separate source
  const templates = projects.filter(
    (p) => p.marketplaceApprovalStatus !== "UNLISTED"
  );

  const dashboardData: DashboardData = {
    user,
    projects,
    templates,
    userPlanFeatures: {
      ...userPlanFeatures,
      // Enable all features for local development
      maxDomainsAllowedPerUser: Number.MAX_SAFE_INTEGER,
      maxPublishesAllowedPerUser: Number.MAX_SAFE_INTEGER,
      maxContactEmails: Number.MAX_SAFE_INTEGER,
      allowShareAdminLinks: true,
      allowDynamicData: true,
    },
    publisherHost: new URL(request.url).origin,
  };

  return json(dashboardData);
};

function DashboardClient({ data }: { data: DashboardData }) {
  const [isClient, setIsClient] = useState(false);
  const [isReady, setIsReady] = useState(false);

  // First effect: set client and setup data
  useEffect(() => {
    // Import and call DashboardSetup dynamically to avoid SSR issues
    import("~/dashboard/dashboard").then(({ DashboardSetup }) => {
      DashboardSetup({ data });
      setIsReady(true);
    });
    setIsClient(true);
  }, [data]);

  if (!isClient || !isReady) {
    return null;
  }

  return <Dashboard />;
}

export default function TemplatesRoute() {
  const loaderData = useLoaderData<typeof loader>();
  return <DashboardClient data={loaderData} />;
}
