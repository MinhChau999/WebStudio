/**
 * Simplified origin utilities for local development
 */

export const getRequestOrigin = (urlStr: string) => {
  const url = new URL(urlStr);
  return url.origin;
};

export const isBuilderUrl = (urlStr: string): boolean => {
  const url = new URL(urlStr);
  // For local development, check if it's our local builder origin
  // or if pathname contains /editor/
  const isLocalBuilder =
    url.hostname === "vite.wstd.dev" ||
    url.hostname === "wstd.dev" ||
    url.hostname === "localhost";
  return isLocalBuilder || url.pathname.startsWith("/editor/");
};

export const isCanvasUrl = (urlStr: string): boolean => {
  // Canvas removed for simplified setup
  return false;
};

export const getAuthorizationServerOrigin = (urlStr: string): string => {
  return getRequestOrigin(urlStr);
};
