import { useEffect } from "react";

/**
 * Simplified feature flags - all features enabled for single-admin setup
 * URL parameter features no longer supported after removing feature-flags package
 */
export const useSetFeatures = () => {
  useEffect(() => {
    // All features are enabled by default in simplified setup
    // No need to parse URL parameters or manage feature flags
  }, []);
};
