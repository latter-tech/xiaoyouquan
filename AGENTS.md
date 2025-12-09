# Repository Guidelines

## Project Structure & Module Organization
- Flutter app entry in `lib/main.dart`; screens under `lib/pages`, reusable UI in `lib/widgets`, shared helpers/themes in `lib/common`.
- Data models in `lib/models`; state and providers in `lib/states`; localization resources in `lib/l10n` with generated output in `lib/generated`.
- Assets live in `assets/images` and fonts in `assets/fonts` (both registered in `pubspec.yaml`); platform shells under `android/` and `ios/`.
- Tests sit in `test/` (example `test/widget_test.dart`) and mirror the feature folder where possible.

## Build, Test, and Development Commands
- `flutter pub get` - install or update dependencies.
- `flutter run -d <device>` - launch the app on a simulator, emulator, or Chrome; use `flutter run -d chrome` for web.
- `flutter analyze` - static analysis using the rules in `analysis_options.yaml`.
- `flutter test` - run unit and widget tests headlessly.
- `flutter build apk --release` or `flutter build ios --release` - produce store-ready binaries (requires platform tooling).

## Coding Style & Naming Conventions
- Dart style with 2-space indentation; lints from `flutter_lints`. Prefer `const` constructors/widgets and `final` fields when possible.
- Use lower_snake_case for file names, `UpperCamelCase` for types, `lowerCamelCase` for members, and suffix UI screens with `Page` or `Screen` and components with `Widget`.
- Keep imports ordered (Dart SDK, packages, local) and avoid unused code; favor single quotes unless interpolation or escaping is clearer.

## Testing Guidelines
- Place tests next to the feature in `test/` using `*_test.dart`; mirror widget names for readability.
- Use `flutter test` locally before pushing; add widget tests for new screens and smoke tests for complex flows.
- When adding assets or localized strings, include simple verification (for example, renders without missing assets) to prevent regressions.

## Commit & Pull Request Guidelines
- Commit messages should be short, imperative, and scoped (for example, `Add profile edit page`, `Fix post upload retry`); reference issue IDs when relevant.
- Before opening a PR: run `flutter analyze` and `flutter test`, summarize changes and risk, note new dependencies or config, and include screenshots or screen recordings for UI work.
- Keep PRs focused on one feature or fix; document any manual steps (for example, creating `.env`, updating platform signing) in the description.

## Localization & Assets Tips
- Update ARB or Intl strings in `lib/l10n` and regenerate with your IDE or `flutter gen-l10n` if generation is needed; keep generated output in `lib/generated` committed.
- New images go under `assets/images` with descriptive names; register additional asset folders in `pubspec.yaml`.
- Avoid hardcoding secrets or API keys in the repo; prefer runtime config per platform.
