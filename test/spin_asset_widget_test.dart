import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spin_from_assets/src/rendering/asset_source.dart';

void main() {
  testWidgets('a network image source renders an Image widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SpinAsset(
          source: 'https://example.com/wheel.png',
          width: 100,
          height: 100,
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
    await tester.pump();
    tester.takeException(); // clear the (expected) failed network fetch
  });

  testWidgets('networkErrorBuilder is shown when a network image fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SpinAsset(
          source: 'https://example.com/does-not-exist.png',
          width: 100,
          height: 100,
          errorBuilder: (context, error) => const Text('load-failed'),
        ),
      ),
    );
    // Let the failing network request resolve, then the error widget appears.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('load-failed'), findsOneWidget);
    tester.takeException();
  });

  testWidgets('a network source with no builders falls back to empty space', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SpinAsset(source: 'https://example.com/x.png'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // No loading/error builder provided -> nothing is drawn in their place.
    expect(find.byType(SizedBox), findsWidgets);
    tester.takeException();
  });
}
