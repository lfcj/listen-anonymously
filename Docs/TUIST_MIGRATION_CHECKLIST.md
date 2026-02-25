# Tuist Migration Checklist

Use this checklist to ensure a smooth migration from `.pbxproj` to Tuist.

## Pre-Migration

- [ ] Backup the current `.xcodeproj` directory
  ```bash
  cp -R "Listen anonymously.xcodeproj" "Listen anonymously.xcodeproj.backup"
  ```

- [ ] Commit all current changes to git
  ```bash
  git add .
  git commit -m "Backup before Tuist migration"
  ```

- [ ] Document current build settings from Xcode
  - Open the project in Xcode
  - Note down any custom build settings per target
  - Screenshot or export build settings if needed

- [ ] List all current targets and their configurations
  - Main app bundle ID
  - Extension bundle ID
  - Framework bundle ID
  - All test targets

- [ ] Note all SPM dependencies and their versions
  - Check Package.resolved if it exists
  - Document exact versions for reproducibility

## Installation

- [ ] Install Tuist
  ```bash
  curl -Ls https://install.tuist.io | bash
  ```

- [ ] Verify Tuist installation
  ```bash
  tuist version
  ```

## Configuration

- [ ] Review and adjust `Project.swift`
  - [ ] Verify bundle IDs match existing project
  - [ ] Verify deployment target is correct (iOS 18)
  - [ ] Verify all targets are included
  - [ ] Check source paths match your folder structure
  - [ ] Check resource paths match your folder structure
  - [ ] Verify external dependencies are listed

- [ ] Review and adjust `Package.swift`
  - [ ] Verify SPM package URLs
  - [ ] Verify version constraints
  - [ ] Check product types configuration

- [ ] Review and adjust `Config.swift`
  - [ ] Verify Xcode version compatibility
  - [ ] Verify Swift version

- [ ] Create `Secrets.xcconfig`
  ```bash
  cp Secrets.xcconfig.example Secrets.xcconfig
  # Edit with your actual values
  ```

- [ ] Verify xcconfig files
  - [ ] Debug.xcconfig includes Secrets.xcconfig
  - [ ] Release.xcconfig includes Secrets.xcconfig
  - [ ] DEVELOPMENT_TEAM references $(DEV_TEAM_SECRET)
  - [ ] Deployment target is set correctly

## Project Structure Verification

Before generating, verify your folder structure matches what's defined in `Project.swift`:

- [ ] `Listen anonymously/Sources/` exists
- [ ] `Listen anonymously/Resources/` exists (if needed)
- [ ] `Listen anonymously Ext/Sources/` exists
- [ ] `Listen anonymously Ext/Resources/` exists (if needed)
- [ ] `Listen Anonymously Shared/Sources/` exists
- [ ] `Listen Anonymously Shared/Resources/` exists (if needed)
- [ ] Test folders exist as expected

**Note:** If your structure is different, update the paths in `Project.swift` accordingly.

## Generation

- [ ] Install SPM dependencies
  ```bash
  tuist install
  ```

- [ ] Generate Xcode project
  ```bash
  tuist generate
  ```

- [ ] Verify generation completed without errors

## Verification

- [ ] Open generated workspace
  ```bash
  open "Listen anonymously.xcworkspace"
  ```

- [ ] Verify all targets appear in Xcode
  - [ ] Listen anonymously (app)
  - [ ] Listen anonymously Ext (extension)
  - [ ] Listen Anonymously Shared (framework)
  - [ ] All test targets

- [ ] Verify build settings for each target
  - [ ] DEVELOPMENT_TEAM is set to $(DEV_TEAM_SECRET)
  - [ ] CODE_SIGN_STYLE is Manual
  - [ ] Deployment target is iOS 18
  - [ ] Bundle IDs are correct

- [ ] Verify Info.plist values
  - [ ] PostHog API key is referenced as $(POSTHOG_API_KEY)
  - [ ] RevenueCat API key is referenced as $(REVENUE_CAT_KEY)
  - [ ] Extension configuration is correct

- [ ] Verify SPM dependencies are resolved
  - [ ] RevenueCat
  - [ ] PostHog
  - [ ] ViewInspector

## Build & Test

- [ ] Clean build folder (Cmd+Shift+K)

- [ ] Build main app target (Cmd+B)
  - [ ] Build succeeds without errors
  - [ ] No new warnings introduced

- [ ] Build extension target
  - [ ] Build succeeds without errors

- [ ] Build framework target
  - [ ] Build succeeds without errors

- [ ] Run all tests (Cmd+U)
  - [ ] All tests pass
  - [ ] Code coverage is collected
  - [ ] Coverage percentage is similar to before migration

- [ ] Run the app on simulator
  - [ ] App launches successfully
  - [ ] All features work as expected
  - [ ] Extension works when sharing audio files

- [ ] Test with physical device (if possible)
  - [ ] App installs correctly
  - [ ] Code signing works
  - [ ] All features work on device

## Fastlane Integration

- [ ] Update Fastfile to use workspace
  ```ruby
  workspace: "Listen anonymously.xcworkspace"
  ```

- [ ] Test Fastlane lanes
  ```bash
  bundle exec fastlane ios all_tests
  ```

- [ ] Verify Fastlane still works correctly

## CI/CD Updates

- [ ] Update GitHub Actions workflow
  - [ ] Add Tuist installation step
  - [ ] Add Secrets.xcconfig creation step
  - [ ] Add tuist install step
  - [ ] Add tuist generate step
  - [ ] Update xcodebuild to use workspace
  - [ ] Update coverage export paths if needed

- [ ] Test CI/CD pipeline
  - [ ] Create a test branch
  - [ ] Push changes
  - [ ] Verify workflow runs successfully
  - [ ] Verify tests pass in CI
  - [ ] Verify coverage upload works

## Git Configuration

- [ ] Update `.gitignore`
  - [ ] Add `.tuist/`
  - [ ] Add `Tuist/Dependencies/`
  - [ ] Add `*.xcodeproj`
  - [ ] Add `*.xcworkspace`
  - [ ] Add `Derived/`
  - [ ] Keep `Secrets.xcconfig`

- [ ] Add Tuist files to git
  ```bash
  git add Project.swift Package.swift Config.swift
  git add Secrets.xcconfig.example
  git add TUIST_SETUP.md TUIST_MIGRATION_CHECKLIST.md
  git add .gitignore
  git add .github/workflows/tuist-tests.yml
  ```

- [ ] Verify `.xcodeproj` is not tracked anymore
  ```bash
  git status
  # Should not show .xcodeproj as modified
  ```

## Documentation

- [ ] Update README.md
  - [ ] Add Tuist setup instructions
  - [ ] Update build instructions
  - [ ] Add link to TUIST_SETUP.md

- [ ] Update team documentation
  - [ ] Onboarding guide
  - [ ] Development setup guide
  - [ ] Troubleshooting guide

- [ ] Create internal announcement (if applicable)
  - [ ] Explain what changed
  - [ ] Provide migration instructions for team
  - [ ] Offer to help team members with setup

## Cleanup

- [ ] Remove backup .xcodeproj (only after confirming everything works)
  ```bash
  rm -rf "Listen anonymously.xcodeproj.backup"
  ```

- [ ] Remove old Package.resolved if present and not needed
  ```bash
  rm Package.resolved  # Tuist manages this
  ```

## Final Verification

- [ ] Clone repository to a fresh location
- [ ] Follow TUIST_SETUP.md from scratch
- [ ] Verify new developers can build without issues
- [ ] Verify CI/CD passes on main branch

## Commit Migration

- [ ] Commit all Tuist files
  ```bash
  git add .
  git commit -m "Migrate to Tuist for project generation
  
  - Remove .xcodeproj from version control
  - Add Project.swift for declarative project configuration
  - Add Package.swift for SPM dependencies
  - Update .gitignore for Tuist artifacts
  - Update CI/CD for Tuist workflow
  - Maintain secret management via Secrets.xcconfig
  "
  ```

- [ ] Push to repository
  ```bash
  git push origin main
  ```

- [ ] Create PR if using feature branch workflow

## Post-Migration

- [ ] Monitor CI/CD for any issues
- [ ] Collect feedback from team
- [ ] Update documentation based on feedback
- [ ] Consider enabling Tuist Cloud for caching (optional)

## Rollback Plan (if needed)

If something goes wrong and you need to rollback:

1. Restore the backup .xcodeproj
   ```bash
   rm -rf "Listen anonymously.xcodeproj"
   mv "Listen anonymously.xcodeproj.backup" "Listen anonymously.xcodeproj"
   ```

2. Revert git changes
   ```bash
   git reset --hard HEAD~1  # Or specific commit
   ```

3. Clean Tuist artifacts
   ```bash
   tuist clean
   rm -rf .tuist
   ```

4. Open the restored project
   ```bash
   open "Listen anonymously.xcodeproj"
   ```

---

## Notes

- The migration preserves all existing build settings
- `DEVELOPMENT_TEAM` remains secure via Secrets.xcconfig
- All xcconfig files are still used and respected
- SPM dependencies are managed via Package.swift
- Generated .xcodeproj is identical to manually configured one

## Questions or Issues?

- Review TUIST_SETUP.md for detailed information
- Check [Tuist Documentation](https://docs.tuist.io)
- Check [Tuist GitHub Issues](https://github.com/tuist/tuist/issues)
- Ask in [Tuist Community](https://community.tuist.io)
