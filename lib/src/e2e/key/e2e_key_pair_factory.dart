import 'package:flutter_e2e/src/e2e/key/key_pair_factory.dart';
import 'package:flutter_e2e/src/e2e/key/sodium_key_pair.dart' as k;
import 'package:sodium_libs/sodium_libs.dart';

class E2eKeyPairFactory implements KeyPairFactory {
  final Sodium sodium;

  E2eKeyPairFactory(this.sodium);

  @override
  k.SodiumKeyPair create() {
    final keyPair = sodium.crypto.kx.keyPair();
    return k.SodiumKeyPair(
      pk: keyPair.publicKey,
      sk: keyPair.secretKey,
    );
  }
}
