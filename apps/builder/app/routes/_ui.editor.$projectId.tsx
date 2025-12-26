import { lazy } from "react";
import { useLoaderData, useParams } from "@remix-run/react";
import type { MetaFunction, ShouldRevalidateFunction } from "@remix-run/react";
import {
  json,
  type HeadersArgs,
  type LoaderFunctionArgs,
} from "@remix-run/server-runtime";
import * as projectApi from "@webstudio-is/project/index.server";

import { createContext } from "~/shared/context.server";

import env from "~/env/env.server";

import builderStyles from "~/builder/builder.css?url";
import { ClientOnly } from "~/shared/client-only";
import { preventCrossOriginCookie } from "~/services/no-cross-origin-cookie";
import {
  allowedDestinations,
  isFetchDestination,
} from "~/services/destinations.server";
export { ErrorBoundary } from "~/shared/error/error-boundary";

export const links = () => {
  return [{ rel: "stylesheet", href: builderStyles }];
};

export const meta: MetaFunction<typeof loader> = ({ data }) => {
  const metas: ReturnType<MetaFunction> = [];

  if (data === undefined) {
    return metas;
  }

  return metas;
};

/**
 * Simplified editor loader - no authentication required
 * Single admin user can access all projects
 */
export const loader = async (loaderArgs: LoaderFunctionArgs) => {
  const { request, params } = loaderArgs;
  preventCrossOriginCookie(request);
  allowedDestinations(request, ["document", "empty"]);

  if (isFetchDestination(request)) {
    // Remix does not provide a built-in way to add CSRF tokens to data fetches,
    // such as client-side navigation or data refreshes.
    // Therefore, ensure that all data fetched here is not sensitive and does not require CSRF protection.
  }

  const context = await createContext(request);

  try {
    const projectId = params.projectId;

    if (projectId === undefined) {
      throw new Response("Project ID is not defined", {
        status: 404,
      });
    }

    const start = Date.now();
    const project = await projectApi.loadById(projectId, context);

    if (project === null) {
      throw new Response(`Project "${projectId}" not found`, {
        status: 404,
      });
    }

    const end = Date.now();
    const diff = end - start;

    // we need to log timings to figure out how to speed up loading
    console.info(`Project ${project.id} is loaded in ${diff}ms`);

    const headers = new Headers();

    headers.set(
      "Content-Security-Policy",
      `frame-src 'self'; worker-src 'none'`
    );

    return json(
      {
        projectId: project.id,
        authPermit: "own", // All projects owned by admin
        userPlanFeatures: {
          // Enable all features for single admin
          aiAssistants: true,
          cloneProjects: true,
          maxProjects: Number.MAX_SAFE_INTEGER,
        },
        authTokenPermissions: {
          canEdit: true,
          canBuild: true,
          canClone: true,
          canCopy: true,
          canPublish: true,
        },
        stagingUsername: env.STAGING_USERNAME,
        stagingPassword: env.STAGING_PASSWORD,
      } as const,
      {
        headers,
      }
    );
  } catch (error) {
    // For simplified setup, redirect to dashboard on any error
    // if (error instanceof Response) {
    //   throw error;
    // }
    console.error("Editor loader error:", error);
    throw error;
  }
};

/**
 * When doing changes in a project, then navigating to a dashboard then pressing the back button,
 * the builder page may display stale data because it's being retrieved from the browser's back/forward cache (bfcache).
 *
 * https://web.dev/articles/bfcache
 *
 */
export const headers = ({ loaderHeaders }: HeadersArgs) => {
  return {
    "Cache-Control": "no-store",
    "Content-Security-Policy": loaderHeaders.get("Content-Security-Policy"),
  };
};

const Builder = lazy(async () => {
  const { Builder } = await import("~/builder/index.client");
  return { default: Builder };
});

const EditorRoute = () => {
  const data = useLoaderData<typeof loader>();
  const params = useParams();

  return (
    <ClientOnly>
      {/* Using a key here ensures that certain effects are re-executed inside the builder,
      especially in cases like cloning a project */}
      <Builder key={params.projectId ?? data.projectId} {...data} />
    </ClientOnly>
  );
};

export const shouldRevalidate: ShouldRevalidateFunction = () => false;

export default EditorRoute;
