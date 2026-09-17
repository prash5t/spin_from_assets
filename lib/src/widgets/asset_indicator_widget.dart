part of '../../spin_from_assets.dart';

/// The fixed pointer rendered around the wheel.
///
/// Positions and rotates the indicator artwork according to
/// [indicatorPosition]. Created internally by [AssetWheelWidget].
class AssetIndicatorWidget extends StatelessWidget {
  /// Creates an [AssetIndicatorWidget].
  const AssetIndicatorWidget({
    super.key,
    required this.assetIndicatorImgLottieSVG,
    required this.indicatorSize,
    required this.indicatorOffset,
    required this.indicatorPosition,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// The indicator asset path or network URL (image, SVG or Lottie).
  final String assetIndicatorImgLottieSVG;

  /// The width/height the indicator is rendered at.
  final double indicatorSize;

  /// Distance the indicator is pushed away from the wheel edge.
  final double indicatorOffset;

  /// Which side of the wheel the indicator sits on.
  final WheelIndicatorPosition indicatorPosition;

  /// Shown while a network indicator asset is loading.
  final NetworkAssetLoadingBuilder? loadingBuilder;

  /// Shown when a network indicator asset fails to load.
  final NetworkAssetErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: indicatorPosition == WheelIndicatorPosition.top
          ? -indicatorSize / 2 - indicatorOffset
          : null,
      bottom: indicatorPosition == WheelIndicatorPosition.bottom
          ? -indicatorSize / 2 - indicatorOffset
          : null,
      left: indicatorPosition == WheelIndicatorPosition.left
          ? -indicatorSize / 2 - indicatorOffset
          : null,
      right: indicatorPosition == WheelIndicatorPosition.right
          ? -indicatorSize / 2 - indicatorOffset
          : null,
      child: Transform.rotate(
        angle: indicatorPosition.getIndicatorRotation,
        child: SpinAsset(
          source: assetIndicatorImgLottieSVG,
          height: indicatorSize,
          width: indicatorSize,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }
}
