import { publicStaticEnv } from "~/env/env.static";
import { getAuthorizationServerOrigin } from "./origins";
import type { BuilderMode } from "../nano-states/misc";

const searchParams = (params: Record<string, string | undefined | null>) => {
  const searchParams = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (typeof value === "string") {
      searchParams.set(key, value);
    }
  }
  const asString = searchParams.toString();
  return asString === "" ? "" : `?${asString}`;
};

export const builderPath = ({
  projectId,
  pageId,
  authToken,
  pageHash,
  mode,
}: {
  projectId: string;
  pageId?: string;
  authToken?: string;
  pageHash?: string;
  mode?: "preview" | "content";
}) => {
  return `/editor/${projectId}${searchParams({
    pageId,
    authToken,
    pageHash,
    mode,
  })}`;
};

/**
 * Simplified builder URL using path-based routing for local development
 * Returns /editor/:projectId instead of subdomain-based URL
 */
export const builderUrl = (props: {
  projectId: string;
  pageId?: string;
  origin: string;
  authToken?: string;
  mode?: BuilderMode;
}) => {
  const authServerOrigin = getAuthorizationServerOrigin(props.origin);

  const url = new URL(`/editor/${props.projectId}`, authServerOrigin);

  if (props.pageId !== undefined) {
    url.searchParams.set("pageId", props.pageId);
  }

  if (props.authToken !== undefined) {
    url.searchParams.set("authToken", props.authToken);
  }

  if (props.mode !== undefined) {
    url.searchParams.set("mode", props.mode);
  }

  return url.href;
};

export const dashboardPath = (
  view: "templates" | "search" | "projects" = "projects"
) => {
  if (view === "projects") {
    return `/`;
  }
  return `/${view}`;
};

/**
 * Simplified editor path for /editor/:projectId
 * Used in local development setup
 */
export const editorPath = (projectId: string) => {
  return `/editor/${projectId}`;
};

export const dashboardUrl = (props: { origin: string }) => {
  const authServerOrigin = getAuthorizationServerOrigin(props.origin);

  return `${authServerOrigin}/`;
};

export const cloneProjectUrl = (props: {
  origin: string;
  sourceAuthToken: string;
}) => {
  const authServerOrigin = getAuthorizationServerOrigin(props.origin);

  const searchParams = new URLSearchParams();
  searchParams.set("projectToCloneAuthToken", props.sourceAuthToken);

  return `${authServerOrigin}/dashboard?${searchParams.toString()}`;
};

export const loginPath = (params: {
  error?: string;
  message?: string;
  returnTo?: string;
}) => `/login${searchParams(params)}`;

export const logoutPath = () => "/logout";
export const restLogoutPath = () => "/dashboard-logout";

export const userPlanSubscriptionPath = () => {
  const urlSearchParams = new URLSearchParams();
  urlSearchParams.set("return_url", window.location.href);

  return `/n8n/billing_portal/sessions?${urlSearchParams.toString()}`;
};

export const restAssetsPath = () => {
  return `/rest/assets`;
};

export const restAssetsUploadPath = ({
  name,
  width,
  height,
}: {
  name: string;
  width?: number | undefined;
  height?: number | undefined;
}) => {
  const urlSearchParams = new URLSearchParams();
  if (width !== undefined) {
    urlSearchParams.set("width", String(width));
  }
  if (height !== undefined) {
    urlSearchParams.set("height", String(height));
  }

  if (urlSearchParams.size > 0) {
    return `/rest/assets/${name}?${urlSearchParams.toString()}`;
  }

  return `/rest/assets/${name}`;
};

export const restPatchPath = () => {
  const urlSearchParams = new URLSearchParams();

  urlSearchParams.set("client-version", publicStaticEnv.VERSION);

  const urlSearchParamsString = urlSearchParams.toString();

  return `/rest/patch${
    urlSearchParamsString ? `?${urlSearchParamsString}` : ""
  }`;
};

// Canvas removed for simplified setup
export const getCanvasUrl = () => `/canvas`;

export const restResourcesLoader = () => `/rest/resources-loader`;

// Marketplace removed for simplified setup
export const marketplacePath = (method: string) => `/#marketplace-removed`;
