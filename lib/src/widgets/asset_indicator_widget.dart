part of '../../spin_from_assets.dart';

class AssetIndicatorWidget extends StatelessWidget {
  final String assetIndicatorImgLottieSVG;
  final double indicatorSize;
  final double indicatorOffset;
  final WheelIndicatorPosition indicatorPosition;

  const AssetIndicatorWidget({
    super.key,
    required this.assetIndicatorImgLottieSVG,
    required this.indicatorSize,
    required this.indicatorOffset,
    required this.indicatorPosition,
  });

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
        child: (assetIndicatorImgLottieSVG).toSVGOrImageOrLottie(
          h: indicatorSize,
          w: indicatorSize,
        ),
      ),
    );
  }
}
