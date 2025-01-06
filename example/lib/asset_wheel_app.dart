import 'package:example/exports.dart';

class AssetWheelApp extends StatelessWidget {
  const AssetWheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
