part of '../../spin_from_assets.dart';

enum WheelIndicatorPosition {
  top,
  right,
  bottom,
  left;

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
