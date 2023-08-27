import 'dart:ffi';

import 'package:sodium/sodium.ffi.dart' as sf;
import 'package:sodium/sodium_sumo.dart' as ss;
import 'package:sodium_libs/sodium_libs.dart' as sl;

/// macOS platform implementation of SodiumPlatform
class SodiumMacos extends sl.SodiumPlatform {
  /// Registers the [SodiumMacos] as [SodiumPlatform.instance]
  static void registerWith() {
    sl.SodiumPlatform.instance = SodiumMacos();
  }

  DynamicLibrary get open =>
      DynamicLibrary.open('/usr/local/lib/libsodium.dylib');

  @override
  Future<sl.Sodium> loadSodium() => sf.SodiumInit.init2(() => open);

  @override
  Future<ss.SodiumSumo> loadSodiumSumo() => ss.SodiumSumoInit.init2(() => open);
}
