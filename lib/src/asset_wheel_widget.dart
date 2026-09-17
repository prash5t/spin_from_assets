part of '../spin_from_assets.dart';

/// A spinning wheel built entirely from your own assets.
///
/// The [wheelAsset] and [indicatorAsset] can each be a bundled asset path or an
/// `http`/`https` URL, and may be a raster image (`.png`, `.jpg`, `.jpeg`,
/// `.webp`, `.gif`, `.bmp`), an SVG (`.svg`) or a Lottie animation (`.json`).
///
/// Trigger a spin from the callback handed to [onSpinButtonPressed], and read
/// the result in [onItemSelected]:
///
/// ```dart
/// late final void Function(int) spin;
///
/// AssetWheelWidget(
///   diameter: 300,
///   itemsCount: 8,
///   spinSound: 'assets/sounds/spin.mp3',
///   selectSound: 'assets/sounds/select.mp3',
///   wheelAsset: 'assets/images/wheel.png',            // or a network URL
///   indicatorAsset: 'https://example.com/pointer.svg', // network is fine too
///   onSpinButtonPressed: (spinTo) => spin = spinTo,
///   onItemSelected: (index) => debugPrint('Selected $index'),
/// );
///
/// // later, e.g. from a button:
/// spin(3);
/// ```
class AssetWheelWidget extends StatefulWidget {
  /// Diameter of the wheel, in logical pixels.
  final double diameter;

  /// How long a spin animation lasts, in seconds. Defaults to `3`.
  final double spinDurationInSeconds;

  /// Width/height of the indicator, in logical pixels. Defaults to `50`.
  final double indicatorSize;

  /// Distance the indicator is offset outward from the wheel edge.
  final double indicatorOffset;

  /// Number of equal segments on the wheel.
  final int itemsCount;

  /// Called with the selected segment index once a spin settles.
  final Function(int) onItemSelected;

  /// Hands you a `spin` function you can store and call to start a spin.
  ///
  /// The function takes the index of the segment to land on:
  /// `onSpinButtonPressed: (spin) => _spin = spin;` then `_spin(2);`.
  final void Function(Function(int)) onSpinButtonPressed;

  /// Which side of the wheel the indicator sits on. Defaults to
  /// [WheelIndicatorPosition.top].
  final WheelIndicatorPosition indicatorPosition;

  /// Asset path for the spin sound effect.
  ///
  /// Provided for convenience; play it from your own callbacks (see the
  /// example's `SoundService`). The widget itself does not play audio.
  final String spinSound;

  /// Asset path for the selection sound effect.
  ///
  /// Provided for convenience; play it from your own callbacks (see the
  /// example's `SoundService`). The widget itself does not play audio.
  final String selectSound;

  /// The indicator artwork: a local asset path or an `http`/`https` URL.
  ///
  /// Supports PNG, JPG, JPEG, WEBP, GIF, BMP, SVG and Lottie (`.json`).
  final String indicatorAsset;

  /// The wheel artwork: a local asset path or an `http`/`https` URL.
  ///
  /// Supports PNG, JPG, JPEG, WEBP, GIF, BMP, SVG and Lottie (`.json`).
  final String wheelAsset;

  /// Builds the widget shown **while a network** wheel or indicator asset is
  /// loading. Ignored for local assets. When omitted, nothing is shown.
  final NetworkAssetLoadingBuilder? networkLoadingBuilder;

  /// Builds the widget shown **when a network** wheel or indicator asset fails
  /// to load. Ignored for local assets. When omitted, nothing is shown.
  final NetworkAssetErrorBuilder? networkErrorBuilder;

  /// Creates an [AssetWheelWidget].
  const AssetWheelWidget({
    super.key,
    required this.diameter,
    required this.itemsCount,
    required this.spinSound,
    required this.selectSound,
    required this.onItemSelected,
    required this.onSpinButtonPressed,
    required this.indicatorAsset,
    required this.wheelAsset,
    this.indicatorPosition = WheelIndicatorPosition.top,
    this.spinDurationInSeconds = 3,
    this.indicatorSize = 50,
    this.indicatorOffset = 0,
    this.networkLoadingBuilder,
    this.networkErrorBuilder,
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
              child: SpinAsset(
                source: widget.wheelAsset,
                height: widget.diameter,
                width: widget.diameter,
                loadingBuilder: widget.networkLoadingBuilder,
                errorBuilder: widget.networkErrorBuilder,
              ),
            );
          },
        ),
        AssetIndicatorWidget(
          assetIndicatorImgLottieSVG: widget.indicatorAsset,
          indicatorSize: widget.indicatorSize,
          indicatorOffset: widget.indicatorOffset,
          indicatorPosition: widget.indicatorPosition,
          loadingBuilder: widget.networkLoadingBuilder,
          errorBuilder: widget.networkErrorBuilder,
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
