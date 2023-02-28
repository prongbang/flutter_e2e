import 'dart:typed_data';

import 'package:flutter_e2e/src/e2e/nonce/nonce_utility.dart';
import 'package:sodium_libs/sodium_libs.dart';

class SodiumNonceUtility extends NonceUtility {
  final Sodium sodium;

  SodiumNonceUtility(this.sodium);

  @override
  Uint8List random() {
    return sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
  }
}
