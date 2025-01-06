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
