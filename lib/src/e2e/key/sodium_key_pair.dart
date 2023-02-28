import 'dart:typed_data';

import 'package:sodium_libs/sodium_libs.dart';

class SodiumKeyPair {
  Uint8List pk;
  SecureKey sk;

  SodiumKeyPair({required this.pk, required this.sk});
}
