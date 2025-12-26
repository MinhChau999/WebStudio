# Optimization Plan - WebStudio Local Dev

## Current Status

**Packages**: 18 → 15 (removed: cli, sdk-cli, generate-arg-types)
**Builder Features**: 14 folders
**Total Size**: ~45MB (11MB packages + 34MB apps/builder)

---

## Priority 1 - Easy Wins (Low Risk)

### 1. Dashboard Package & Routes

- **Package**: `packages/dashboard` - Dashboard UI components
- **Routes**: `apps/builder/app/dashboard/` - Dashboard pages
- **Impact**: Medium - Project listing/management UI
- **When**: If you always open editor directly with project ID

```bash
# Remove
rm -rf packages/dashboard
rm -rf apps/builder/app/dashboard/
```

### 2. Help Feature

- **Path**: `apps/builder/app/builder/features/help/`
- **Impact**: Low - Help documentation popup
- **Files**: ~5-10 files

### 3. Keyboard Shortcuts Dialog

- **Path**: `apps/builder/app/builder/features/keyboard-shortcuts-dialog/`
- **Impact**: Low - Help dialog for shortcuts

### 4. Blocking Alerts

- **Path**: `apps/builder/app/builder/features/blocking-alerts/`
- **Impact**: Low - Alert modals

---

## Priority 2 - Medium (Consider Carefully)

### 5. Footer Feature

- **Path**: `apps/builder/app/builder/features/footer/`
- **Impact**: Low - Footer UI in builder

### 6. Address Bar

- **Path**: `apps/builder/app/builder/features/address-bar.tsx`
- **Impact**: Medium - URL/path display in topbar
- **Note**: Useful for navigation, but can be simplified

### 7. Dashboard Route

- **File**: `apps/builder/app/routes/_ui._index.tsx` - Dashboard home page
- **Impact**: Medium - Entry point for dashboard
- **Keep**: Editor route (`_ui.editor.$projectId.tsx`)

---

## Priority 3 - Dependencies Cleanup

### 8. Remove Unused Dev Dependencies

```bash
# Check for unused packages
pnpm exec depcheck apps/builder/
```

### 9. Clean Up Peer Dependency Warnings

- vitest version mismatch (expected, safe to ignore)
- @vercel/remix version mismatches (expected)

---

## Recommended Action Plan

### Phase 1: Non-Essential Features (Safe to remove)

1. `features/help/` - Help center popup
2. `features/keyboard-shortcuts-dialog/` - Shortcuts help
3. `features/blocking-alerts/` - Alert modals

**Expected savings**: ~500KB - 1MB

### Phase 2: Dashboard (Optional)

4. `packages/dashboard/` - Dashboard components
5. `apps/builder/app/dashboard/` - Dashboard routes
6. `routes/_ui._index.tsx` - Dashboard home

**Expected savings**: ~2-3MB

**After this**: Users must access editor via `/editor/{projectId}` directly

### Phase 3: UI Polish

7. `features/footer/` - Footer component
8. Simplify `features/address-bar.tsx` - URL bar

**Expected savings**: ~200KB

---

## Keep (Essential)

✅ **Core Builder Features**:

- components, pages, navigator, assets, marketplace
- style-panel, settings-panel
- workspace, topbar, breakpoints

✅ **Essential Packages**:

- design-system, icons, image
- css-engine, css-data, html-data
- project, project-build, react-sdk
- sdk, sdk-components-react
- trpc-interface, postgrest, prisma-client
- asset-uploader, http-client, fonts, template

---

## Questions

1. **Dashboard needed?** - Can users always open `/editor/{projectId}` directly?
2. **Help center?** - Is documentation popup needed?
3. **Keyboard shortcuts?** - Is the shortcuts dialog useful?
4. **Address bar?** - Is URL display needed in topbar?

---

## Estimated Impact

| Phase     | Items             | Size Savings | Risk   |
| --------- | ----------------- | ------------ | ------ |
| 1         | 3 features        | ~1MB         | Low    |
| 2         | Dashboard         | ~2-3MB       | Medium |
| 3         | Footer/AddressBar | ~200KB       | Low    |
| **Total** | **6-8 items**     | **~3-4MB**   | -      |
