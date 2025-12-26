import { lazy } from "react";
import type { LoaderFunctionArgs } from "@remix-run/server-runtime";
import { Meta, Links, Scripts, ScrollRestoration } from "@remix-run/react";
import { isCanvas } from "~/shared/router-utils";
import { ClientOnly } from "~/shared/client-only";

export { ErrorBoundary } from "~/shared/error/error-boundary";

export const loader = async ({ request }: LoaderFunctionArgs) => {
  if (isCanvas(request) === false) {
    throw new Response("Not Found", {
      status: 404,
    });
  }
  return {};
};

const Canvas = lazy(async () => {
  const { Canvas } = await import("~/canvas/index.client");
  return { default: Canvas };
});

const CanvasRoute = () => {
  return (
    <html lang="en">
      <head>
        <Meta />
        <Links />
      </head>
      <ClientOnly
        fallback={
          <body>
            <Scripts />
            <ScrollRestoration />
          </body>
        }
      >
        <Canvas />
      </ClientOnly>
    </html>
  );
};

export default CanvasRoute;
