import { isBuilderUrl } from "./origins";

export const isBuilder = (request: Request): boolean => {
  const url = new URL(request.url);
  return url.pathname.startsWith("/editor/");
};

export const isCanvas = (request: Request): boolean => {
  const url = new URL(request.url);
  // Check if pathname is /canvas and origin is builder URL
  return url.pathname === "/canvas" && isBuilderUrl(url.origin);
};

export const isDashboard = (request: Request): boolean => {
  const url = new URL(request.url);
  return url.pathname === "/" || url.pathname === "/dashboard";
};

export const comparePathnames = (
  pathnameOrUrlA: string,
  pathnameOrUrlB: string
) => {
  const aPathname = new URL(pathnameOrUrlA, "http://localhost").pathname;
  const bPathname = new URL(pathnameOrUrlB, "http://localhost").pathname;
  return aPathname === bPathname;
};

export const compareUrls = (urlA: string, urlB: string) => {
  const aPathname = new URL(urlA, "http://localhost").href;
  const bPathname = new URL(urlB, "http://localhost").href;
  return aPathname === bPathname;
};
