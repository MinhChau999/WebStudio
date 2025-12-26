# Simplification Report - 2025-12-26

## Completed

### Phase 1: Storybook Removal ✅

- **Files removed:** ~105 `.stories.tsx` files
- **Directory removed:** `.storybook/`
- **Dependencies removed:** @storybook/\* packages

### Phase 2: Test Fixtures Removal ✅

- **Directory removed:** `fixtures/` (8 test fixture projects)

### Phase 3: Publishing/Deployment Features ✅

- **Package removed:** `packages/domain/`
- **UI files removed:** cname.ts, publish.tsx, section-publish.tsx

### Phase 4: CLI Packages Removal ✅

- **Packages removed:**
  - `packages/cli` - CLI tool
  - `packages/sdk-cli` - SDK CLI
  - `packages/generate-arg-types` - Type generator
- **Updated:** `packages/sdk-components-react/package.json`

### Phase 5: Marketplace Panel Restoration ✅

- **Restored:** `apps/builder/app/builder/features/marketplace/`
- **Re-integrated:** Marketplace panel in sidebar
- **Files:** 7 files (marketplace.tsx, overview.tsx, templates.tsx, etc.)

---

## Summary

| Category      | Files/Packages | Status      |
| ------------- | -------------- | ----------- |
| Storybook     | ~105 files     | ✅ Removed  |
| Test Fixtures | 8 projects     | ✅ Removed  |
| Publishing    | domain + UI    | ✅ Removed  |
| CLI Tools     | 3 packages     | ✅ Removed  |
| Marketplace   | 7 files        | ✅ Restored |

---

## Current State

**Packages**: 24 → 21 → **18** (removed 6, kept marketplace)

**Remaining Packages**:

- asset-uploader, css-data, css-engine, dashboard
- design-system, fonts, html-data, http-client
- icons, image, postgrest, prisma-client
- project, project-build, react-sdk
- sdk, sdk-components-react, sdk-components-react-remix
- template, trpc-interface, tsconfig

**Builder Features**: 14 folders

- assets, components, pages, navigator, marketplace
- style-panel, settings-panel, breakpoints
- workspace, topbar, help, keyboard-shortcuts-dialog
- blocking-alerts, footer, address-bar

---

## Next Steps (Optional)

See [2025-12-26-optimization-plan.md](../2025-12-26-optimization-plan.md)

**Priority 1**: Help, Keyboard Shortcuts, Blocking Alerts (~1MB)
**Priority 2**: Dashboard package & routes (~2-3MB)
**Priority 3**: Footer, Address Bar simplification (~200KB)

---

## Preserved

- ✅ AI features (AI command bar, suggestions)
- ✅ Collaboration features (multi-user editing)
- ✅ Core builder functionality
- ✅ Canvas and editor
- ✅ Marketplace panel (browsing templates)
