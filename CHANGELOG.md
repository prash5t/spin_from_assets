## [1.1.0] - 2026-09-17

### Added

- **Network assets.** `wheelAsset` and `indicatorAsset` now accept `http`/`https`
  URLs as well as local asset paths — the source is auto-detected, so passing a
  URL "just works". Supported over the network: images
  (PNG/JPG/JPEG/WEBP/GIF/BMP), SVG (`.svg`) and Lottie (`.json`).
- `networkLoadingBuilder` and `networkErrorBuilder` — optional callbacks that
  build a widget to show while a network asset loads or when it fails. Both are
  optional and default to showing nothing (an empty `SizedBox`).
- Extra image formats: WEBP, GIF and BMP (previously PNG/JPG/JPEG only).

### Changed

- Modernized for current Flutter/Dart — verified on Flutter 3.41.8 / Dart 3.11.5.
- Bumped `flutter_svg` to `^2.3.0`, `lottie` to `^3.3.0`, `flutter_lints` to `^6.0.0`.
- Documented the entire public API (dartdoc).
- URL extension detection now ignores query strings and fragments
  (e.g. `.../wheel.png?v=2`).

### Removed

- The internal `String` rendering extension (`toSvg` / `toImage` / `toLottie` /
  `toSVGOrImageOrLottie`) is no longer exported. It was undocumented internal
  machinery that added methods to every `String` in your app; rendering is now
  handled internally by the package.

## [1.0.0] - 2025-01-06

- Build spinning wheels with your business logic and designer's assets.
