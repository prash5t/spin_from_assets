## Why Choose `spin_from_assets`?

**spin_from_assets** is a unique and visually stunning spinning wheel widget for Flutter. Unlike traditional spinning wheel packages, this package allows you to use custom assets designed by your team (images, SVGs, or Lottie animations) to create an engaging and professional look. Say goodbye to generic programmatically drawn wheels and hello to a tailored design experience!

<img src="https://i.ibb.co/D8yDT0X/cover.jpg">

## Key Features

- **Custom Assets:** Supports PNG, JPG, JPEG, SVG, and Lottie animations for the wheel and indicator
- **Business Logic Handled:** Automatically calculates the selected item, spin duration, and more
- **Highly Customizable:** Adjust wheel size, spin duration, indicator size, position, and offset
- **Developer-Friendly:** Focus on functionality while the package handles the visuals and animations

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  spin_from_assets: ^1.0.0
```

Run:

```bash
flutter pub get
```

## How to Use

### Example

Here is how you can integrate `spin_from_assets` into your Flutter app:

```dart
import 'package:example/exports.dart';

class AssetWheelScreen extends StatefulWidget {
  const AssetWheelScreen({super.key});

  @override
  State<AssetWheelScreen> createState() => _AssetWheelScreenState();
}

class _AssetWheelScreenState extends State<AssetWheelScreen> {
  late final Function({required int indexToSelect}) spinWheel;
  final SoundService soundService = SoundService();

  @override
  void initState() {
    super.initState();
    soundService.stopSpinSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AssetWheelWidget(
              diameter: 300,
              itemsCount: 8,
              spinSound: AssetPathConstants.spinSound,
              selectSound: AssetPathConstants.selectSound,
              indicatorPosition: WheelIndicatorPosition.top,
              spinDurationInSeconds: 3.0,
              onItemSelected: (index) {
                debugPrint('Selected Index: $index');
                soundService.stopSpinSound();
                soundService.playSelectSound(AssetPathConstants.selectSound);
              },
              onSpinButtonPressed: (spin) {
                spinWheel = ({required int indexToSelect}) {
                  spin(indexToSelect);
                };
              },
              indicatorAsset: AssetPathConstants.indicator,
              wheelAsset: AssetPathConstants.wheel16,
              indicatorSize: 50,
              indicatorOffset: 0,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              spinWheel(indexToSelect: 1);
              soundService.playSpinSound(AssetPathConstants.spinSound);
            },
            child: const Text(TextConstants.spinWheel),
          ),
        ],
      ),
    );
  }
}

```

## Properties

### AssetWheelWidget

| Property                | Type                      | Description                                                   | Default                      |
| ----------------------- | ------------------------- | ------------------------------------------------------------- | ---------------------------- |
| `diameter`              | `double`                  | Diameter of the wheel                                         | Required                     |
| `itemsCount`            | `int`                     | Number of segments on the wheel                               | Required                     |
| `wheelAsset`            | `String`                  | Asset path for the wheel (supports PNG, JPG, SVG, Lottie)     | Required                     |
| `indicatorAsset`        | `String`                  | Asset path for the indicator (supports PNG, JPG, SVG, Lottie) | Required                     |
| `spinSound`             | `String`                  | Asset path for the spin sound effect                          | Required                     |
| `selectSound`           | `String`                  | Asset path for the select sound effect                        | Required                     |
| `spinDurationInSeconds` | `double`                  | Duration of the spin animation                                | `3.0`                        |
| `indicatorPosition`     | `WheelIndicatorPosition`  | Position of the indicator (top, right, bottom, left)          | `WheelIndicatorPosition.top` |
| `indicatorSize`         | `double`                  | Size of the indicator                                         | `50.0`                       |
| `indicatorOffset`       | `double`                  | Offset of the indicator from the wheel                        | `0.0`                        |
| `onSpinButtonPressed`   | `Function(Function(int))` | Callback to trigger the spin and specify the target index     | Required                     |
| `onItemSelected`        | `Function(int)`           | Callback for the selected item index after the spin           | Required                     |

## Contributing

Visit [https://github.com/prash5t/spin_from_assets](https://github.com/prash5t/spin_from_assets) to explore more and further customize/contribute as you wish. :)
Danke schön!
