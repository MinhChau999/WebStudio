import { type LoaderFunctionArgs } from "@remix-run/server-runtime";
import { type MetaFunction } from "@remix-run/react";
import { preventCrossOriginCookie } from "~/services/no-cross-origin-cookie";
export { ErrorBoundary } from "~/shared/error/error-boundary";

export const meta: MetaFunction = () => {
  const metas: ReturnType<MetaFunction> = [];

  metas.push({ title: "Webstudio Error" });

  return metas;
};

const developmentErrors = [
  {
    message: "Unknown error",
    description: undefined,
  },

  {
    message:
      "Unknown error Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    description: undefined,
  },

  {
    message: "Unknown error",
    description:
      "Unknown error Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  },
  {
    message:
      "Unknown error Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    description:
      "Unknown error Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  },
  {
    message:
      "UnknownerrorLoremIpsumissimplydummytextoftheprintingandtypesettingindustry.LoremIpsumhasbeentheindustry'sstandarddummytexteversincethe1500s,whenanunknownprintertookagalleyoftypeandscrambledittomakeatypespecimenbook.Ithassurvivednotonlyfivecenturies,butalsotheleapintoelectronictypesetting,remainingessentiallyunchanged.Itwaspopularisedinthe1960swiththereleaseofLetrasetsheetscontainingLoremIpsumpassages,andmorerecentlywithdesktoppublishingsoftwarelikeAldusPageMakerincludingversionsofLoremIpsum.",
    description:
      "UnknownerrorLoremIpsumissimplydummytextoftheprintingandtypesettingindustry.LoremIpsumhasbeentheindustry'sstandarddummytexteversincethe1500s,whenanunknownprintertookagalleyoftypeandscrambledittomakeatypespecimenbook.Ithassurvivednotonlyfivecenturies,butalsotheleapintoelectronictypesetting,remainingessentiallyunchanged.Itwaspopularisedinthe1960swiththereleaseofLetrasetsheetscontainingLoremIpsumpassages,andmorerecentlywithdesktoppublishingsoftwarelikeAldusPageMakerincludingversionsofLoremIpsum.",
  },
];

export const loader = async ({ request }: LoaderFunctionArgs) => {
  preventCrossOriginCookie(request);

  // We leave it here because production errors in remix has a different behavior
  // https://wstd.dev:5173/error?development-error=0
  // https://wstd.dev:5173/error?development-error=1
  // ...
  const url = new URL(request.url);
  if (url.searchParams.has("development-error")) {
    const index = Number(url.searchParams.get("development-error"));
    if (index >= 0 && index < developmentErrors.length) {
      throw new Response(JSON.stringify(developmentErrors[index]), {
        status: 400,
        headers: {
          "Content-Type": "application/json",
        },
      });
    }
  }

  throw new Response(
    JSON.stringify({
      message: "Unknown error",
      description: "",
    }),
    {
      status: 400,
      headers: {
        "Content-Type": "application/json",
      },
    }
  );
};

export default function Error() {
  // Placeholder component to prevent Remix warning:
  // "Matched leaf route at location '/{SOME_LOCATION}' does not have an element or Component."
  // Without this, an <Outlet /> with a null value would render an empty page.
  return (
    <div>
      <h1>Error</h1>
      <p>Unknown error.</p>
    </div>
  );
}
