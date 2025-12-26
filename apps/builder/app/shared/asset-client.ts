import * as path from "node:path";
import { MaxSize } from "@webstudio-is/asset-uploader";
import { createFsClient } from "@webstudio-is/asset-uploader/index.server";
import env from "~/env/env.server";

export const fileUploadPath = "public/uploads/assets";

/**
 * Create asset client - local filesystem only
 * S3 support removed for simplified deployment
 */
export const createAssetClient = () => {
  const maxUploadSize = MaxSize.parse(env.MAX_UPLOAD_SIZE);
  return createFsClient({
    maxUploadSize,
    fileDirectory: path.join(process.cwd(), fileUploadPath),
  });
};
