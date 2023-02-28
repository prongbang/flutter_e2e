import 'package:flutter_e2e/src/e2e/key/shared_key.dart';
import 'package:flutter_e2e/src/e2e/key/shared_key_factory.dart';
import 'package:flutter_e2e/src/e2e/key/sodium_key_pair.dart' as k;
import 'package:sodium_libs/sodium_libs.dart';

/// Document:
/// Precalculation interface
/// https://libsodium.gitbook.io/doc/public-key_cryptography/authenticated_encryption#precalculation-interface
class E2eSharedKeyFactory implements SharedKeyFactory {
  final Sodium sodium;

  E2eSharedKeyFactory(this.sodium);

  @override
  SharedKey create(k.SodiumKeyPair keyPair) {
    final precalcBox = sodium.crypto.box.precalculate(
      publicKey: keyPair.pk,
      secretKey: keyPair.sk,
    );
    return SharedKey(precalcBox: precalcBox);
  }
}
