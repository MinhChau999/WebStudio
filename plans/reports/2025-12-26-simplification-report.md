# Simplification Report - 2025-12-26

## Completed

### Phase 1: Storybook Removal ✅

- **Files removed:** ~105 `.stories.tsx` files
- **Directory removed:** `.storybook/`
- **Dependencies removed from package.json:**
  - `@storybook/addon-actions`
  - `@storybook/addon-backgrounds`
  - `@storybook/addon-controls`
  - `@storybook/react`
  - `@storybook/react-vite`
  - `storybook`
- **Scripts removed:** `storybook:dev`, `storybook:build`

### Phase 2: Test Fixtures Removal ✅

- **Directory removed:** `fixtures/` (8 test fixture projects)
  - react-router-cloudflare
  - react-router-docker
  - react-router-netlify
  - react-router-vercel
  - ssg
  - ssg-netlify-by-project-id
  - webstudio-cloudflare-template
  - webstudio-features
- **Build script updated:** Removed `--filter='!./fixtures/*'`

### Phase 3: Publishing/Deployment Features ✅

- **Package removed:** `packages/domain/` (9 files)
  - Domain management
  - CNAME handling
  - Domain validation
- **UI files removed:**
  - `apps/builder/app/builder/features/topbar/cname.ts`
  - `apps/builder/app/builder/features/topbar/publish.tsx`
  - `apps/builder/app/shared/project-settings/section-publish.tsx`

### Phase 4: Documentation ✅

- Already removed in previous commits:
  - `CODE_OF_CONDUCT.md`
  - GitHub issue templates

### Phase 5: Dependencies ✅

- Ran `pnpm install` to clean up
- Peer dependency warnings (non-blocking):
  - vitest version mismatch
  - @vercel/remix version mismatches (expected)

## Summary

| Category      | Files/Directories                   | Status     |
| ------------- | ----------------------------------- | ---------- |
| Storybook     | ~105 files + .storybook             | ✅ Removed |
| Test Fixtures | 8 fixture projects                  | ✅ Removed |
| Publishing    | domain package (9 files) + UI files | ✅ Removed |
| Documentation | Already removed                     | ✅ Done    |

## Preserved

- ✅ AI features (AI command bar, suggestions)
- ✅ Collaboration features (multi-user editing)
- ✅ Core builder functionality
- ✅ Canvas and editor

## Next Steps (Optional)

- Fix peer dependency warnings (if needed)
- Remove unused dependencies from individual packages
- Clean up any remaining deployment-related code
- Remove GitHub workflows if not needed for local dev
