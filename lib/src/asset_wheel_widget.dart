part of '../spin_from_assets.dart';

class AssetWheelWidget extends StatefulWidget {
  final double diameter;
  final double spinDurationInSeconds;
  final double indicatorSize;
  final double indicatorOffset;
  final int itemsCount;
  final Function(int) onItemSelected;
  final void Function(Function(int)) onSpinButtonPressed;
  final WheelIndicatorPosition indicatorPosition;
  final String spinSound;
  final String selectSound;

  /// Supports PNG, JPG, JPEG, SVG, Lottie
  final String indicatorAsset;

  /// Supports PNG, JPG, JPEG, SVG, Lottie
  final String wheelAsset;

  const AssetWheelWidget({
    super.key,
    required this.diameter,
    required this.itemsCount,
    required this.spinSound,
    required this.selectSound,
    required this.onItemSelected,
    required this.onSpinButtonPressed,
    this.indicatorPosition = WheelIndicatorPosition.top,
    this.spinDurationInSeconds = 3,
    this.indicatorSize = 50,
    required this.indicatorAsset,
    required this.wheelAsset,
    this.indicatorOffset = 0,
  });

  @override
  State<AssetWheelWidget> createState() => _AssetWheelWidgetState();
}

class _AssetWheelWidgetState extends State<AssetWheelWidget> {
  late final AssetWheelController wheelController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ValueListenableBuilder<double>(
          valueListenable: wheelController,
          builder: (context, rotation, child) {
            return Transform.rotate(
              angle: rotation,
              child: widget.wheelAsset.toSVGOrImageOrLottie(
                h: widget.diameter,
                w: widget.diameter,
              ),
            );
          },
        ),
        AssetIndicatorWidget(
          assetIndicatorImgLottieSVG: widget.indicatorAsset,
          indicatorSize: widget.indicatorSize,
          indicatorOffset: widget.indicatorOffset,
          indicatorPosition: widget.indicatorPosition,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    wheelController = AssetWheelController();
    wheelController.addListener(_onWheelStateChanged);

    widget.onSpinButtonPressed((int indexToSelect) {
      final targetAngle = _calculateTargetAngle(indexToSelect);
      wheelController.spinToTarget(targetAngle, widget.spinDurationInSeconds);
    });
  }

  void _onWheelStateChanged() {
    if (wheelController.isSpinning) {
    } else if (!wheelController.isSpinning) {
      if (wheelController.hasCompletedSpin) {
        final selectedItem = _getSelectedItemIndex();
        widget.onItemSelected(selectedItem);
      }
    }
  }

  double _calculateTargetAngle(int indexToSelect) {
    final segmentAngle = 2 * math.pi / widget.itemsCount;
    final centerAngle = segmentAngle * indexToSelect +
        (segmentAngle / 2) +
        widget.indicatorPosition.angleOffset;
    return centerAngle + (2 * math.pi * 8);
  }

  int _getSelectedItemIndex() {
    final segmentAngle = 2 * math.pi / widget.itemsCount;
    final normalizedAngle =
        ((wheelController.value - widget.indicatorPosition.angleOffset) %
            (2 * math.pi));
    final index = (normalizedAngle / segmentAngle).floor();
    return index;
  }

  @override
  void dispose() {
    wheelController.removeListener(_onWheelStateChanged);
    wheelController.dispose();
    super.dispose();
  }
}
