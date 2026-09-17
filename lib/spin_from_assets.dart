/// Build spinning wheels from your designer's assets — local **or** network.
///
/// `spin_from_assets` renders a wheel and an indicator from your own images
/// (`.png`, `.jpg`, `.jpeg`, `.webp`, `.gif`, `.bmp`), SVGs (`.svg`) or Lottie
/// animations (`.json`), drives the spin animation and reports the selected
/// item. Each asset can be a bundled asset path **or** an `http`/`https` URL.
///
/// See [AssetWheelWidget] for the entry point.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'src/rendering/asset_source.dart';

export 'src/rendering/asset_source.dart'
    show NetworkAssetLoadingBuilder, NetworkAssetErrorBuilder;

part 'src/asset_wheel_widget.dart';
part 'src/controllers/asset_wheel_controller.dart';
part 'src/enums/indicator_position_enum.dart';
part 'src/widgets/asset_indicator_widget.dart';
