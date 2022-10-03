import 'dart:typed_data';

import 'package:flutter_e2e/src/e2e/key/shared_key_factory.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class E2eSharedKeyFactory implements SharedKeyFactory {
  @override
  Uint8List create(KeyPair keyPair) =>
      Sodium.cryptoBoxBeforenm(keyPair.pk, keyPair.sk);
}
