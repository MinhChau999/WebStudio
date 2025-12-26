# Simplify WebStudio for Book Editing

**Goal:** Remove unnecessary features from WebStudio, keeping only:

- Dashboard (projects + templates)
- Canvas (book editing)

**Date:** 2025-12-26
**Status:** Planning

---

## Overview

WebStudio contains many features not needed for internal book editing. This plan outlines what to remove.

---

## Routes to Remove

```
apps/builder/app/routes/
├── ❌ REMOVE: auth.dev.tsx                    # Dev authentication
├── ❌ REMOVE: auth.github.tsx                 # GitHub OAuth
├── ❌ REMOVE: auth.github_.callback.tsx       # GitHub callback
├── ❌ REMOVE: auth.google.tsx                 # Google OAuth
├── ❌ REMOVE: auth.google_.callback.tsx       # Google callback
├── ❌ REMOVE: oauth.ws.authorize.tsx          # OAuth authorization
├── ❌ REMOVE: oauth.ws.token.tsx              # OAuth token endpoint
├── ❌ REMOVE: _ui.dashboard.search.tsx        # Search page
├── ❌ REMOVE: _ui.dashboard.templates.tsx     # Separate templates page
├── ❌ REMOVE: _ui.login._index.tsx            # Login page
├── ❌ REMOVE: _ui.logout.tsx                  # Logout functionality
├── ❌ REMOVE: n8n.$.tsx                       # n8n automation integration
├── ❌ REMOVE: rest.build.$buildId.tsx         # Build endpoint
└── ❌ REMOVE: rest.buildId.$projectId.tsx     # Publishing endpoint

├── ✅ KEEP: _ui.tsx                          # Base layout
├── ✅ KEEP: _ui.$.tsx                        # Catchall/404
├── ✅ KEEP: _ui.dashboard._index.tsx          # Dashboard (projects + templates)
├── ✅ KEEP: _ui.dashboard.tsx                # Dashboard layout
├── ✅ KEEP: _canvas.canvas.tsx               # Canvas editor
├── ✅ KEEP: _canvas.tsx                      # Canvas layout
├── ✅ KEEP: rest.assets.tsx                  # Asset API
├── ✅ KEEP: rest.assets_.$name.tsx           # Asset upload
├── ✅ KEEP: rest.data.$projectId.ts          # Project data
├── ✅ KEEP: rest.patch.ts                    # Save changes
```

---

## Packages to Remove

```
packages/
├── ❌ REMOVE: authorization-token/           # Auth tokens (no auth needed)
├── ❌ REMOVE: feature-flags/                 # Feature flagging
├── ❌ REMOVE: http-client/                   # Can use fetch directly
├── ❌ REMOVE: cli/                           # CLI tools
├── ❌ REMOVE: sdk-cli/                       # SDK CLI
├── ❌ REMOVE: sdk-components-animation/      # Proprietary animation
├── ❌ REMOVE: sdk-components-react-router/   # Router components
├── ❌ REMOVE: sdk-components-react-radix/    # Extra Radix components

├── ⚠️  SIMPLIFY: asset-uploader/              # Keep but simplify
├── ⚠️  SIMPLIFY: fonts/                       # Keep basic fonts
├── ⚠️  SIMPLIFY: image/                       # Keep basic image processing

├── ✅ KEEP: sdk/                             # Core SDK
├── ✅ KEEP: react-sdk/                       # React runtime
├── ✅ KEEP: css-engine/                      # CSS rendering
├── ✅ KEEP: design-system/                   # UI components
├── ✅ KEEP: project/                         # Project logic
├── ✅ KEEP: project-build/                   # Build system
├── ✅ KEEP: prisma-client/                   # Database (can replace later)
├── ✅ KEEP: postgrest/                       # API client (can replace later)
├── ✅ KEEP: trpc-interface/                  # API layer (can replace later)
├── ✅ KEEP: dashboard/                       # Dashboard UI
├── ✅ KEEP: template/                        # Templates
├── ✅ KEEP: domain/                          # Domain models
├── ✅ KEEP: tsconfig/                        # TS config
├── ✅ KEEP: css-data/                        # CSS properties data
└── ✅ KEEP: sdk-components-react/            # Base components
```

---

## Builder Features to Remove

```
apps/builder/app/builder/features/
├── ❌ REMOVE: marketplace/                   # Entire marketplace
├── ❌ REMOVE: command-panel/                 # Advanced command palette
├── ❌ REMOVE: ai-command-bar/                # AI features

apps/builder/app/builder/features/workspace/
├── ❌ REMOVE: canvas-iframe.tsx             # (check - might be needed)

apps/builder/app/builder/features/settings-panel/
├── ❌ REMOVE: section-backups.tsx           # Backup management
├── ❌ REMOVE: section-publish.tsx           # Publishing settings
├── ❌ REMOVE: section-redirects.tsx         # Redirect management

apps/builder/app/shared/
├── ❌ REMOVE: share-project/                 # Project sharing
├── ❌ REMOVE: project-settings/section-marketplace.tsx
├── ❌ REMOVE: copy-paste/plugin-webflow/    # Webflow import
└── ❌ REMOVE: copy-paste/plugin-markdown/   # Markdown import
```

---

## Dashboard Features to Remove

```
apps/builder/app/builder/features/dashboard/
├── ❌ REMOVE: search.tsx                     # Search functionality
├── ❌ REMOVE: templates.tsx                  # Separate templates page

apps/builder/app/dashboard/shared/
├── ❌ REMOVE: card.tsx                       # (check if needed)
```

---

## Dependencies to Check

These packages may have cross-dependencies. Check before removing:

```typescript
// Check if these are imported by packages we're keeping
authorization-token → used by rest.*, auth.*
feature-flags → used by builder features
sdk-components-react-radix → used by builder
```

---

## Removal Steps

### Phase 1: Remove Routes (Easiest)

```bash
# Remove auth routes
rm apps/builder/app/routes/auth.dev.tsx
rm apps/builder/app/routes/auth.github.tsx
rm apps/builder/app/routes/auth.github_.callback.tsx
rm apps/builder/app/routes/auth.google.tsx
rm apps/builder/app/routes/auth.google_.callback.tsx

# Remove OAuth
rm apps/builder/app/routes/oauth.ws.authorize.tsx
rm apps/builder/app/routes/oauth.ws.token.tsx

# Remove other unused routes
rm apps/builder/app/routes/_ui.dashboard.search.tsx
rm apps/builder/app/routes/_ui.dashboard.templates.tsx
rm apps/builder/app/routes/_ui.login._index.tsx
rm apps/builder/app/routes/_ui.logout.tsx
rm apps/builder/app/routes/n8n.$.tsx
rm apps/builder/app/routes/rest.build.$buildId.tsx
rm apps/builder/app/routes/rest.buildId.$projectId.tsx
```

### Phase 2: Remove Builder Features

```bash
# Marketplace
rm -rf apps/builder/app/builder/features/marketplace

# Command panel
rm -rf apps/builder/app/builder/features/command-panel

# AI features
rm -rf apps/builder/app/builder/features/ai-command-bar

# Settings panel features
rm apps/builder/app/builder/features/settings-panel/section-backups.tsx
rm apps/builder/app/builder/features/settings-panel/section-publish.tsx
rm apps/builder/app/builder/features/settings-panel/section-redirects.tsx

# Shared features
rm -rf apps/builder/app/shared/share-project
rm -rf apps/builder/app/shared/copy-paste/plugin-webflow
rm -rf apps/builder/app/shared/copy-paste/plugin-markdown
```

### Phase 3: Remove Packages

```bash
# WARNING: Check dependencies first!
rm -rf packages/authorization-token
rm -rf packages/feature-flags
rm -rf packages/cli
rm -rf packages/sdk-cli
rm -rf packages/sdk-components-animation
rm -rf packages/sdk-components-react-router
rm -rf packages/sdk-components-react-radix
```

### Phase 4: Update Dependencies

```bash
# Update package.json files that reference removed packages
# This will be done manually based on import errors
```

### Phase 5: Test

```bash
pnpm install
pnpm build
pnpm dev

# Test:
# 1. Dashboard loads
# 2. Can create/edit project
# 3. Canvas works
# 4. Can save changes
```

---

## Estimated Impact

| Metric          | Before | After   | Reduction |
| --------------- | ------ | ------- | --------- |
| **Packages**    | 32     | ~24     | ~25%      |
| **Routes**      | ~20    | ~10     | ~50%      |
| **Bundle size** | ~2MB   | ~1.5MB  | ~25%      |
| **Build time**  | ~2min  | ~1.5min | ~25%      |

---

## Risk Assessment

| Risk                 | Level  | Mitigation                            |
| -------------------- | ------ | ------------------------------------- |
| Breaking imports     | High   | Use TypeScript to find all references |
| Canvas functionality | Medium | Test canvas after each removal        |
| Dashboard features   | Low    | Simple project list                   |
| Data persistence     | Medium | Keep rest.patch.ts                    |

---

## Questions

1. **Authentication:** Do you need ANY authentication? Or completely open (internal only)?
2. **User management:** Do you need multiple users or just single admin?
3. **Project permissions:** Do you need project ownership or all projects shared?
4. **Templates:** Do you need template system or just blank projects?
5. **Asset storage:** S3, R2, or local filesystem?

---

## Next Steps

1. Answer questions above
2. Backup current code (`git commit`)
3. Start with Phase 1 (Remove Routes)
4. Test after each phase
5. Fix import errors
6. Final testing
