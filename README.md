## Why Choose `spin_from_assets`?

**spin_from_assets** is a unique and visually stunning spinning wheel widget for Flutter. Unlike traditional spinning wheel packages, this package allows you to use custom assets designed by your team (images, SVGs, or Lottie animations) to create an engaging and professional look. Say goodbye to generic programmatically drawn wheels and hello to a tailored design experience!

<img src="https://i.ibb.co/D8yDT0X/cover.jpg">

## Key Features

- **Custom Assets:** Supports PNG, JPG, JPEG, WEBP, GIF, BMP, SVG, and Lottie animations for the wheel and indicator
- **Local or Network:** Every asset can be a bundled asset path **or** an `http`/`https` URL — the source is auto-detected
- **Graceful Network States:** Optional builders to show your own loading and error widgets for network assets
- **Business Logic Handled:** Automatically calculates the selected item, spin duration, and more
- **Highly Customizable:** Adjust wheel size, spin duration, indicator size, position, and offset
- **Developer-Friendly:** Focus on functionality while the package handles the visuals and animations

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  spin_from_assets: ^1.1.0
```

Run:

```bash
flutter pub get
```

## How to Use

### Example

Here is how you can integrate `spin_from_assets` into your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:spin_from_assets/spin_from_assets.dart';

class AssetWheelScreen extends StatefulWidget {
  const AssetWheelScreen({super.key});

  @override
  State<AssetWheelScreen> createState() => _AssetWheelScreenState();
}

class _AssetWheelScreenState extends State<AssetWheelScreen> {
  late final void Function(int indexToSelect) spinWheel;

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
              spinSound: 'assets/sounds/spin.mp3',
              selectSound: 'assets/sounds/select.mp3',
              indicatorPosition: WheelIndicatorPosition.top,
              spinDurationInSeconds: 3.0,
              wheelAsset: 'assets/images/wheel_8.png',
              indicatorAsset: 'assets/images/indicator.png',
              indicatorSize: 50,
              indicatorOffset: 0,
              onItemSelected: (index) {
                debugPrint('Selected Index: $index');
              },
              onSpinButtonPressed: (spin) {
                spinWheel = spin;
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => spinWheel(1),
            child: const Text('Spin Wheel'),
          ),
        ],
      ),
    );
  }
}
```

### Network assets

Pass an `http`/`https` URL to `wheelAsset` and/or `indicatorAsset` and it is loaded
from the network automatically — no other change required. Use the optional
`networkLoadingBuilder` / `networkErrorBuilder` to show your own widgets while a
network asset loads or if it fails (both default to showing nothing):

```dart
AssetWheelWidget(
  diameter: 300,
  itemsCount: 8,
  spinSound: 'assets/sounds/spin.mp3',
  selectSound: 'assets/sounds/select.mp3',
  wheelAsset: 'https://your.cdn/wheel_8.png',      // network image
  indicatorAsset: 'https://your.cdn/indicator.svg', // network SVG
  onItemSelected: (index) => debugPrint('Selected: $index'),
  onSpinButtonPressed: (spin) => spinWheel = spin,
  networkLoadingBuilder: (context) => const Center(
    child: CircularProgressIndicator(),
  ),
  networkErrorBuilder: (context, error) => const Icon(
    Icons.broken_image_outlined,
    size: 48,
  ),
);
```

Supported formats (local **and** network): images (`.png`, `.jpg`, `.jpeg`,
`.webp`, `.gif`, `.bmp`), SVG (`.svg`) and Lottie (`.json`). URLs with query
strings (for example `wheel.png?v=2`) are handled correctly.

> Note: the widget does not play audio. `spinSound` / `selectSound` are provided
> for convenience — play them from your own callbacks (see the `example/`, which
> uses `audioplayers`).

## Properties

### AssetWheelWidget

| Property                | Type                                    | Description                                                                    | Default                      |
| ----------------------- | --------------------------------------- | ------------------------------------------------------------------------------ | ---------------------------- |
| `diameter`              | `double`                                | Diameter of the wheel                                                          | Required                     |
| `itemsCount`            | `int`                                   | Number of segments on the wheel                                                | Required                     |
| `wheelAsset`            | `String`                                | Asset path **or** URL for the wheel (image, SVG or Lottie)                     | Required                     |
| `indicatorAsset`        | `String`                                | Asset path **or** URL for the indicator (image, SVG or Lottie)                 | Required                     |
| `spinSound`             | `String`                                | Asset path for the spin sound effect (play it yourself)                        | Required                     |
| `selectSound`           | `String`                                | Asset path for the select sound effect (play it yourself)                      | Required                     |
| `spinDurationInSeconds` | `double`                                | Duration of the spin animation                                                 | `3.0`                        |
| `indicatorPosition`     | `WheelIndicatorPosition`                | Position of the indicator (top, right, bottom, left)                           | `WheelIndicatorPosition.top` |
| `indicatorSize`         | `double`                                | Size of the indicator                                                          | `50.0`                       |
| `indicatorOffset`       | `double`                                | Offset of the indicator from the wheel                                         | `0.0`                        |
| `onSpinButtonPressed`   | `Function(Function(int))`               | Callback that hands you a `spin` function; store it and call it to spin        | Required                     |
| `onItemSelected`        | `Function(int)`                         | Callback for the selected item index after the spin                            | Required                     |
| `networkLoadingBuilder` | `Widget Function(BuildContext)?`        | Widget shown while a **network** asset loads (ignored for local assets)        | `null` (shows nothing)       |
| `networkErrorBuilder`   | `Widget Function(BuildContext, Object)?`| Widget shown when a **network** asset fails to load (ignored for local assets) | `null` (shows nothing)       |

## Contributing

Visit [https://github.com/prash5t/spin_from_assets](https://github.com/prash5t/spin_from_assets) to explore more and further customize/contribute as you wish. :)
Danke schön!
