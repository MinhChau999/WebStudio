export const sidebarPanelNames = [
  "assets",
  "components",
  "navigator",
  "pages",
  // "marketplace", // Removed for simplified setup
] as const;

export type SidebarPanelName = (typeof sidebarPanelNames)[number] | "none";
