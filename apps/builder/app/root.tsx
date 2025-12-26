// Our root outlet doesn't contain a layout because we have 2 types of documents: canvas and builder and we need to decide down the line which one to render, thre is no single root document.
import {
  Outlet,
  useLoaderData,
  type ShouldRevalidateFunction,
} from "@remix-run/react";
import { json } from "@remix-run/server-runtime";
import env from "./env/env.server";

export const loader = () => {
  return json({
    features: env.FEATURES,
  });
};

export default function App() {
  const { features } = useLoaderData<typeof loader>();

  // All features enabled for single-admin setup
  // setEnv is not available without feature-flags package

  return <Outlet />;
}

export const shouldRevalidate: ShouldRevalidateFunction = () => {
  return false;
};
