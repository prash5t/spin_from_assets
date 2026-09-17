import 'package:flutter_test/flutter_test.dart';
import 'package:spin_from_assets/src/rendering/asset_source.dart';

void main() {
  group('classifyAssetSource - local assets', () {
    test('png / jpg / jpeg / webp / gif / bmp map to image', () {
      for (final ext in ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp']) {
        final info = classifyAssetSource('assets/images/wheel.$ext');
        expect(info.isNetwork, isFalse, reason: ext);
        expect(info.kind, SpinAssetKind.image, reason: ext);
      }
    });

    test('svg maps to svg', () {
      final info = classifyAssetSource('assets/svg/wheel.svg');
      expect(info.isNetwork, isFalse);
      expect(info.kind, SpinAssetKind.svg);
    });

    test('json maps to lottie', () {
      final info = classifyAssetSource('assets/lottie/wheel.json');
      expect(info.isNetwork, isFalse);
      expect(info.kind, SpinAssetKind.lottie);
    });

    test('unknown extension maps to unknown', () {
      final info = classifyAssetSource('assets/wheel.txt');
      expect(info.kind, SpinAssetKind.unknown);
    });

    test('extension detection is case-insensitive', () {
      expect(classifyAssetSource('WHEEL.PNG').kind, SpinAssetKind.image);
      expect(classifyAssetSource('WHEEL.SVG').kind, SpinAssetKind.svg);
    });
  });

  group('classifyAssetSource - network URLs', () {
    test('http and https are detected as network', () {
      expect(
        classifyAssetSource('http://x.com/wheel.png').isNetwork,
        isTrue,
      );
      expect(
        classifyAssetSource('https://x.com/wheel.png').isNetwork,
        isTrue,
      );
    });

    test('scheme detection is case-insensitive', () {
      expect(classifyAssetSource('HTTPS://x.com/w.png').isNetwork, isTrue);
    });

    test('query strings and fragments do not defeat extension detection', () {
      expect(
        classifyAssetSource('https://cdn.x/wheel.png?v=2&t=abc').kind,
        SpinAssetKind.image,
      );
      expect(
        classifyAssetSource('https://cdn.x/wheel.svg#frag').kind,
        SpinAssetKind.svg,
      );
      expect(
        classifyAssetSource('https://cdn.x/anim.json?cache=false').kind,
        SpinAssetKind.lottie,
      );
    });

    test('network URL keeps both isNetwork and kind', () {
      final info = classifyAssetSource('https://cdn.x/spin.json');
      expect(info.isNetwork, isTrue);
      expect(info.kind, SpinAssetKind.lottie);
    });
  });

  group('AssetSourceInfo value equality', () {
    test('equal fields compare equal', () {
      expect(
        const AssetSourceInfo(isNetwork: true, kind: SpinAssetKind.image),
        const AssetSourceInfo(isNetwork: true, kind: SpinAssetKind.image),
      );
    });
  });
}
