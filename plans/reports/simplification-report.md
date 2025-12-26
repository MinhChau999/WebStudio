# Simplification Report - WebStudio for Book Editing

**Date:** 2025-12-26
**Status:** Phase 1 Complete

---

## Summary

Successfully removed major unnecessary features from WebStudio. **~50 files removed**, **~8 packages deleted**.

---

## Completed ✅

### **Routes Removed (11 files)**

```
✅ auth.dev.tsx
✅ auth.github.tsx, auth.github_.callback.tsx
✅ auth.google.tsx, auth.google_.callback.tsx
✅ oauth.ws.authorize.tsx, oauth.ws.token.tsx
✅ _ui.dashboard.search.tsx
✅ _ui.dashboard.templates.tsx
✅ _ui.login._index.tsx
✅ _ui.logout.tsx
✅ n8n.$.tsx
✅ rest.build.$buildId.tsx
✅ rest.buildId.$projectId.tsx
```

### **Packages Removed (8 packages)**

```
✅ packages/authorization-token/
✅ packages/feature-flags/
✅ packages/template/
✅ packages/cli/
✅ packages/sdk-cli/
✅ packages/sdk-components-animation/
✅ packages/sdk-components-react-router/
✅ packages/sdk-components-react-radix/
```

### **Builder Features Removed**

```
✅ apps/builder/app/builder/features/marketplace/
✅ apps/builder/app/builder/features/command-panel/
✅ apps/builder/app/builder/features/ai-command-bar/
✅ apps/builder/app/builder/features/settings-panel/section-backups.tsx
✅ apps/builder/app/builder/features/settings-panel/section-publish.tsx
✅ apps/builder/app/builder/features/settings-panel/section-redirects.tsx
✅ apps/builder/app/builder/features/settings-panel/section-marketplace.tsx
✅ apps/builder/app/shared/share-project/
✅ apps/builder/app/shared/copy-paste/plugin-webflow/
✅ apps/builder/app/shared/copy-paste/plugin-markdown/
✅ apps/builder/app/builder/features/dashboard/templates.tsx
✅ apps/builder/app/dashboard/shared/card.tsx
```

### **Asset Storage Simplified**

```
✅ Removed S3 client (packages/asset-uploader/src/clients/s3/)
✅ Updated asset-client.ts to use local filesystem only
✅ Changed upload path to "public/uploads/assets"
```

### **Dependencies Updated**

```
✅ Updated apps/builder/package.json (removed 5 dependencies)
```

---

## Remaining Issues ⚠️

### **Import Errors Found (40+ files)**

Many files still import deleted packages. Need to fix:

#### **High Priority (Core functionality)**

```
❌ apps/builder/app/routes/_ui.dashboard.tsx:15
   → import from "@webstudio-is/authorization-token/index.server"

❌ apps/builder/app/routes/_ui.(builder).tsx:15
   → import from "@webstudio-is/authorization-token/index.server"

❌ apps/builder/app/canvas/canvas.tsx:13-20
   → imports from sdk-components-animation, sdk-components-react-radix

❌ apps/builder/app/builder/builder.tsx:54
   → import from @webstudio-is/authorization-token

❌ apps/builder/app/services/trcp-router.server.ts:4
   → import from @webstudio-is/authorization-token

❌ apps/builder/app/root.tsx:8
   → import from @webstudio-is/feature-flags

❌ apps/builder/app/shared/nano-states/misc.ts:14
   → import from @webstudio-is/authorization-token

❌ apps/builder/app/shared/nano-states/components.ts:24
   → import from @webstudio-is/template

❌ apps/builder/app/shared/nano-states/props.test.tsx
   → import from @webstudio-is/feature-flags

❌ apps/builder/app/builder/features/components/components.tsx:5
   → import from @webstudio-is/feature-flags

❌ apps/builder/app/builder/features/pages/page-utils.test.ts
   → import from @webstudio-is/feature-flags

❌ apps/builder/app/builder/features/blocking-alerts/blocking-alerts.tsx:4
   → import from @webstudio-is/feature-flags

❌ apps/builder/app/builder/features/settings-panel/controls/resource-control.tsx:12
   → import from @webstudio-is/feature-flags
```

#### **Medium Priority (Tests)**

```
⚠️  apps/builder/app/shared/awareness.test.tsx
⚠️  apps/builder/app/shared/copy-paste.test.tsx
⚠️  apps/builder/app/shared/data-variables.test.tsx
⚠️  apps/builder/app/shared/content-model.test.tsx
⚠️  apps/builder/app/shared/style-object-model.test.tsx
⚠️  apps/builder/app/shared/instance-utils.test.tsx
⚠️  apps/builder/app/shared/page-utils.test.tsx
⚠️  apps/builder/app/shared/html.test.tsx
⚠️  apps/builder/app/shared/matcher.test.tsx
⚠️  apps/builder/app/shared/tailwind/tailwind.test.tsx
⚠️  apps/builder/app/canvas/features/text-editor/*.test.tsx
⚠️  apps/builder/app/canvas/features/text-editor/*.stories.tsx
⚠️  apps/builder/app/shared/copy-paste/plugin-html.test.tsx
⚠️  apps/builder/app/shared/copy-paste/plugin-markdown.test.tsx
⚠️  apps/builder/app/shared/copy-paste/asset-upload.test.tsx
⚠️  apps/builder/app/builder/features/pages/page-utils.test.ts
⚠️  apps/builder/app/builder/features/settings-panel/props-section/animation/set-css-property.test.tsx
⚠️  apps/builder/app/builder/features/style-panel/shared/css-fragment.test.ts
⚠️  apps/builder/app/builder/features/style-panel/shared/repeated-style.test.ts
```

---

## Next Steps

### **Phase 8: Fix Critical Import Errors**

Need to update these files:

1. **Remove auth imports** - simplify dashboard and builder routes
2. **Remove feature flags** - always enable features
3. **Remove template imports** - remove or stub
4. **Remove SDK component imports** - use only base components

### **Commands to Run**

```bash
# After fixing imports
pnpm install
pnpm build
pnpm dev
```

---

## Estimated Remaining Work

| Task                 | Files         | Time         |
| -------------------- | ------------- | ------------ |
| Fix auth imports     | 5 files       | 30 min       |
| Fix feature flags    | 10 files      | 30 min       |
| Fix template imports | 15 files      | 30 min       |
| Fix SDK components   | 3 files       | 15 min       |
| **Total**            | **~33 files** | **~2 hours** |

---

## Risk Assessment

| Risk                                 | Level  | Mitigation                    |
| ------------------------------------ | ------ | ----------------------------- |
| Build fails after removing packages  | HIGH   | Fix imports systematically    |
| Canvas breaks without sdk-components | MEDIUM | Use only base components      |
| Dashboard breaks without auth        | MEDIUM | Remove auth checks            |
| Tests fail                           | LOW    | Can disable tests temporarily |

---

## Questions

1. Should I continue fixing import errors?
2. Should we remove tests entirely (since they use deleted packages heavily)?
3. Do you want to keep ANY authentication (even simple hardcoded user)?

---

**Waiting for user approval to continue.**
