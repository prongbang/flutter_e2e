import 'package:flutter_e2e/src/e2e/key/e2e_shared_key.dart';
import 'package:flutter_e2e/src/e2e/sodium_secret_box_e2e_cryptography.dart';

class SodiumE2eCryptography extends SodiumSecretBoxE2eCryptography {
  SodiumE2eCryptography(E2eSharedKey e2eSharedKey) : super(e2eSharedKey);
}
