import 'package:example/exports.dart';

class AssetWheelScreen extends StatefulWidget {
  const AssetWheelScreen({super.key});

  @override
  State<AssetWheelScreen> createState() => _AssetWheelScreenState();
}

class _AssetWheelScreenState extends State<AssetWheelScreen> {
  late final Function({required int indexToSelect}) spinWheel;
  final SoundService soundService = SoundService();

  /// Toggles the wheel + indicator between bundled assets and network URLs.
  bool _useNetwork = false;

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
          SwitchListTile(
            title: const Text('Load wheel from network (URL)'),
            subtitle: Text(_useNetwork ? 'Network assets' : 'Local assets'),
            value: _useNetwork,
            onChanged: (value) => setState(() => _useNetwork = value),
          ),
          const SizedBox(height: 20),
          Center(
            child: AssetWheelWidget(
              diameter: 300,
              itemsCount: 8,
              spinSound: AssetPathConstants.spinSound,
              selectSound: AssetPathConstants.selectSound,
              indicatorPosition: WheelIndicatorPosition.top,
              spinDurationInSeconds: 3.0,
              wheelAsset: _useNetwork
                  ? AssetPathConstants.networkWheel
                  : AssetPathConstants.wheel8,
              indicatorAsset: _useNetwork
                  ? AssetPathConstants.networkIndicator
                  : AssetPathConstants.indicator,
              indicatorSize: 50,
              indicatorOffset: 0,
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
              // Shown only for network assets while they load / if they fail.
              networkLoadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              networkErrorBuilder: (context, error) => const Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Colors.redAccent,
              ),
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
