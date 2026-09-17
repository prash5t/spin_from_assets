part of '../../spin_from_assets.dart';

/// Where the fixed indicator sits around the wheel, and therefore which segment
/// counts as "selected" when the wheel stops.
enum WheelIndicatorPosition {
  /// Indicator centered at the top of the wheel.
  top,

  /// Indicator centered on the right of the wheel.
  right,

  /// Indicator centered at the bottom of the wheel.
  bottom,

  /// Indicator centered on the left of the wheel.
  left;

  /// The angle (in radians) this position corresponds to on the wheel, used to
  /// map the resting rotation to the selected segment.
  double get angleOffset {
    switch (this) {
      case WheelIndicatorPosition.top:
        return -math.pi / 2; // -90 degrees
      case WheelIndicatorPosition.right:
        return 0; // 0 degrees
      case WheelIndicatorPosition.bottom:
        return math.pi / 2; // 90 degrees
      case WheelIndicatorPosition.left:
        return math.pi; // 180 degrees
    }
  }

  /// The rotation (in radians) applied to the indicator artwork so that it
  /// points inward toward the wheel from this position.
  double get getIndicatorRotation {
    switch (this) {
      case WheelIndicatorPosition.top:
        return 0;
      case WheelIndicatorPosition.right:
        return math.pi / 2; // 90 degrees
      case WheelIndicatorPosition.bottom:
        return math.pi; // 180 degrees
      case WheelIndicatorPosition.left:
        return -math.pi / 2; // -90 degrees
    }
  }
}
