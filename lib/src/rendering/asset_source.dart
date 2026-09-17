import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

/// Signature for a builder that returns the widget shown **while a network
/// wheel or indicator asset is loading**.
///
/// Used by [AssetWheelWidget.networkLoadingBuilder]. When no builder is
/// provided, nothing (an empty [SizedBox]) is shown while loading.
typedef NetworkAssetLoadingBuilder = Widget Function(BuildContext context);

/// Signature for a builder that returns the widget shown **when a network
/// wheel or indicator asset fails to load**.
///
/// The [error] object describes the failure (for example a
/// [NetworkImageLoadException] for images). Used by
/// [AssetWheelWidget.networkErrorBuilder]. When no builder is provided,
/// nothing (an empty [SizedBox]) is shown on failure.
typedef NetworkAssetErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
);

/// The kind of renderer a source string maps to, based on its file extension.
enum SpinAssetKind {
  /// A raster image (`.png`, `.jpg`, `.jpeg`, `.webp`, `.gif`, `.bmp`).
  image,

  /// A scalable vector graphic (`.svg`).
  svg,

  /// A Lottie animation (`.json`).
  lottie,

  /// An unrecognized extension that cannot be rendered.
  unknown,
}

/// The result of classifying a source string: whether it is a network URL and
/// which [SpinAssetKind] should render it.
@immutable
class AssetSourceInfo {
  /// Creates an [AssetSourceInfo].
  const AssetSourceInfo({required this.isNetwork, required this.kind});

  /// Whether the source is a network URL (`http://` or `https://`).
  final bool isNetwork;

  /// The renderer the source maps to.
  final SpinAssetKind kind;

  @override
  bool operator ==(Object other) =>
      other is AssetSourceInfo &&
      other.isNetwork == isNetwork &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(isNetwork, kind);

  @override
  String toString() => 'AssetSourceInfo(isNetwork: $isNetwork, kind: $kind)';
}

/// Classifies a wheel/indicator [source] string.
///
/// A source is treated as a network URL when it starts with `http://` or
/// `https://` (case-insensitive); otherwise it is a local asset path. The
/// [SpinAssetKind] is decided from the file extension of the URL *path*, so
/// query strings and fragments (for example `wheel.png?v=2`) are ignored.
AssetSourceInfo classifyAssetSource(String source) {
  final trimmed = source.trim();
  final lower = trimmed.toLowerCase();
  final isNetwork = lower.startsWith('http://') || lower.startsWith('https://');

  // Read the extension from the path only, so query strings / fragments on a
  // network URL (e.g. `.../wheel.png?token=abc`) do not defeat detection.
  var path = trimmed;
  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.path.isNotEmpty) {
    path = uri.path;
  }
  final lowerPath = path.toLowerCase();

  final SpinAssetKind kind;
  if (lowerPath.endsWith('.svg')) {
    kind = SpinAssetKind.svg;
  } else if (lowerPath.endsWith('.json')) {
    kind = SpinAssetKind.lottie;
  } else if (lowerPath.endsWith('.png') ||
      lowerPath.endsWith('.jpg') ||
      lowerPath.endsWith('.jpeg') ||
      lowerPath.endsWith('.webp') ||
      lowerPath.endsWith('.gif') ||
      lowerPath.endsWith('.bmp')) {
    kind = SpinAssetKind.image;
  } else {
    kind = SpinAssetKind.unknown;
  }

  return AssetSourceInfo(isNetwork: isNetwork, kind: kind);
}

/// Renders a wheel or indicator [source] — a local asset path **or** a network
/// URL — as an image, SVG or Lottie animation.
///
/// The correct renderer and loader (asset vs network) are chosen automatically
/// from [source] via [classifyAssetSource]. [loadingBuilder] and [errorBuilder]
/// are only used for network sources; local assets ignore them.
class SpinAsset extends StatelessWidget {
  /// Creates a [SpinAsset].
  const SpinAsset({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// The local asset path or network URL to render.
  final String source;

  /// The width to render at.
  final double? width;

  /// The height to render at.
  final double? height;

  /// Builds the widget shown while a network [source] is loading.
  final NetworkAssetLoadingBuilder? loadingBuilder;

  /// Builds the widget shown when a network [source] fails to load.
  final NetworkAssetErrorBuilder? errorBuilder;

  Widget _loading(BuildContext context) =>
      loadingBuilder?.call(context) ?? const SizedBox.shrink();

  Widget _error(BuildContext context, Object error) =>
      errorBuilder?.call(context, error) ?? const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final info = classifyAssetSource(source);

    switch (info.kind) {
      case SpinAssetKind.svg:
        return info.isNetwork
            ? SvgPicture.network(
                source,
                width: width,
                height: height,
                placeholderBuilder: _loading,
                errorBuilder: (context, error, _) => _error(context, error),
              )
            : SvgPicture.asset(source, width: width, height: height);

      case SpinAssetKind.lottie:
        return info.isNetwork
            ? Lottie.network(
                source,
                width: width,
                height: height,
                fit: BoxFit.cover,
                repeat: true,
                frameBuilder: (context, child, composition) =>
                    composition == null ? _loading(context) : child,
                errorBuilder: (context, error, _) => _error(context, error),
              )
            : Lottie.asset(
                source,
                width: width,
                height: height,
                fit: BoxFit.cover,
                repeat: true,
              );

      case SpinAssetKind.image:
        return info.isNetwork
            ? Image.network(
                source,
                width: width,
                height: height,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _loading(context),
                errorBuilder: (context, error, _) => _error(context, error),
              )
            : Image.asset(source, width: width, height: height);

      case SpinAssetKind.unknown:
        assert(
          false,
          'spin_from_assets: unsupported asset "$source". Use an image '
          '(.png/.jpg/.jpeg/.webp/.gif/.bmp), an SVG (.svg) or a Lottie (.json).',
        );
        return const SizedBox.shrink();
    }
  }
}
