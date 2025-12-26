/**
 * Add domain component - simplified for local development
 * Domain features are disabled in simplified setup
 */

import { Button, Flex, Grid } from "@webstudio-is/design-system";
import type { Project } from "@webstudio-is/project";
import { TerminalIcon } from "@webstudio-is/icons";
import { builderApi } from "~/shared/builder-api";

type DomainsAddProps = {
  projectId: Project["id"];
  onCreate: (domain: string) => void;
  onExportClick: () => void;
  refresh: () => Promise<void>;
};

export const AddDomain = ({ onExportClick }: DomainsAddProps) => {
  const handleAddDomain = () => {
    builderApi.toast.info(
      "Custom domains are not available in simplified local mode"
    );
  };

  return (
    <Flex gap={2} shrink={false} direction={"column"}>
      <Grid gap={2} columns={2}>
        <Button
          formAction={handleAddDomain}
          color={"neutral"}
          onClick={handleAddDomain}
        >
          Add a new domain
        </Button>

        <Button
          color={"dark"}
          prefix={<TerminalIcon />}
          type="button"
          onClick={onExportClick}
        >
          Export
        </Button>
      </Grid>
    </Flex>
  );
};
