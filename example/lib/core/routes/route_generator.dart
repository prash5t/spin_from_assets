import 'package:example/exports.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Object? argument = settings.arguments;
  switch (settings.name) {
    case AppRoutes.assetWheelScreen:
      return MaterialPageRoute(builder: (context) => const AssetWheelScreen());

    default:
      return MaterialPageRoute(builder: (context) => const AssetWheelScreen());
  }
}
