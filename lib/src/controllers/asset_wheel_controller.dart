part of '../../spin_from_assets.dart';

/// Drives the wheel's rotation.
///
/// A [ValueNotifier] whose value is the current wheel rotation in radians. The
/// widget creates and owns one internally; you normally interact with the wheel
/// through [AssetWheelWidget.onSpinButtonPressed] rather than using this class
/// directly.
class AssetWheelController extends ValueNotifier<double> {
  /// Creates a controller with the wheel at rest (rotation `0`).
  AssetWheelController() : super(0.0) {
    _ticker = Ticker(_onTick);
  }

  late final Ticker _ticker;
  DateTime? _startTime;
  bool _isSpinning = false;
  bool _hasCompletedSpin = false;
  double? _targetAngle;
  double? _startAngle;
  double? _totalDistance;
  double _duration = 0.0;

  /// Whether the wheel is currently animating toward a target.
  bool get isSpinning => _isSpinning;

  /// Whether the most recent spin has finished (used to fire selection).
  bool get hasCompletedSpin => _hasCompletedSpin;

  /// Spins the wheel to [targetAngle] (radians) over [duration] seconds.
  ///
  /// Ignored while a spin is already in progress. Extra full rotations are added
  /// so the wheel always turns clockwise with a lively number of spins.
  void spinToTarget(double targetAngle, double duration) {
    if (_isSpinning) return;

    // Ensure we always rotate clockwise to target with minimum rotations
    double normalizedTarget = targetAngle;
    while (normalizedTarget <= value) {
      normalizedTarget += 2 * math.pi;
    }
    // Add extra rotations for more dramatic effect
    normalizedTarget += 2 * math.pi * 5;

    _targetAngle = normalizedTarget;
    _startAngle = value;
    _totalDistance = _targetAngle! - _startAngle!;
    _duration = duration;
    _startTime = DateTime.now();
    _isSpinning = true;
    _hasCompletedSpin = false;

    _startSpinAnimation();
    notifyListeners();
  }

  void _startSpinAnimation() {
    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!_isSpinning || _startTime == null) return;

    final elapsedSeconds =
        DateTime.now().difference(_startTime!).inMilliseconds / 1000;

    if (elapsedSeconds >= _duration) {
      value = _targetAngle! % (2 * math.pi);
      _isSpinning = false;
      _ticker.stop();
      _hasCompletedSpin = true;
      _targetAngle = null;
      _startTime = null;
      _startAngle = null;
      _totalDistance = null;
      notifyListeners();
      return;
    }

    // Use built-in easing curve
    final progress = elapsedSeconds / _duration;
    final easedProgress = Curves.easeOutCubic.transform(progress);

    final currentDistance = _totalDistance! * easedProgress;
    value = (_startAngle! + currentDistance) % (2 * math.pi);

    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
