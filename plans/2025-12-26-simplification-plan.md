# Simplification Plan - WebStudio Local Dev

## Overview

Remove unnecessary features for simplified local development setup.

## Analysis

### Already Removed (Git Status)

- Marketplace/Templates features
- Authorization tokens package
- Feature flags package
- OAuth providers (GitHub, Google, WS)
- Command panel
- Share project features
- Copy-paste plugin-webflow
- GitHub workflows

### Can Still Remove

## 1. Storybook (~66 files)

**Impact:** Low - Component development tool, not needed for runtime

- `.storybook/` directory
- `*.stories.tsx` files (66 files)
- Storybook dependencies from `package.json`
  - `@storybook/*` packages
  - `storybook:dev` and `storybook:build` scripts

```bash
# Remove
rm -rf .storybook
find . -name "*.stories.tsx" -delete
# Remove from package.json: storybook dependencies
```

## 2. AI Features

**Impact:** Low - AI assistance features

- AI command bar components
- AI-related packages

```bash
# Check and remove
packages/design-system/src/components/ai-command-bar/
```

## 3. Collaboration Features

**Impact:** Medium - Real-time collaboration

- `packages/awareness/`
- Collaboration instance outlines
- Real-time syncing features

## 4. Publishing/Deployment

**Impact:** Medium - Cloud publishing, not needed for local

- Domain management (`packages/domain/`)
- Publishing workflows
- Cloudflare deployment configs
- Vercel deployment configs

## 5. Test Fixtures

**Impact:** Low - Test fixtures not needed for dev

- `fixtures/` directory
- Various test configurations

## 6. Documentation Files

**Impact:** Very Low

- `CODE_OF_CONDUCT.md`
- GitHub issue templates

## 7. Optional: Analytics/Telemetry

**Impact:** Low

- Usage tracking
- Error reporting (Sentry, etc.)

## Priority Order

### Phase 1: Easy Wins (Low Risk)

1. **Storybook** - 66 files, pure dev tool
2. **Test fixtures** - Not needed for basic dev
3. **Documentation** - Extra markdown files

### Phase 2: Features (Medium Risk)

4. **AI features** - If not using AI assistance
5. **Collaboration** - If single-user only
6. **Publishing/Deployment** - If local-only

### Phase 3: Cleanup

7. Unused dependencies
8. Dead code
9. Simplified configs

## Estimated Impact

| Category      | Files | Dependencies | Risk   |
| ------------- | ----- | ------------ | ------ |
| Storybook     | ~70   | ~5 packages  | Low    |
| Fixtures      | ~20   | Minimal      | Low    |
| AI Features   | ~10   | ~2 packages  | Low    |
| Collaboration | ~15   | ~3 packages  | Medium |
| Publishing    | ~30   | ~5 packages  | Medium |

## Questions

1. **Keep AI features?** - AI command bar, suggestions
2. **Keep collaboration?** - Multi-user editing
3. **Keep publishing?** - Or local-only build
4. **Keep analytics?** - Usage tracking

## Next Steps

Confirm which categories to remove, then execute in phases.
