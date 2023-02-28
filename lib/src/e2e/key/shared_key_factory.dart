import 'package:flutter_e2e/src/e2e/key/shared_key.dart';
import 'package:flutter_e2e/src/e2e/key/sodium_key_pair.dart';

abstract class SharedKeyFactory {
  SharedKey create(SodiumKeyPair keyPair);
}
