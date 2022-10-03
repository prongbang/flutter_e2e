import 'package:flutter_e2e/src/e2e/key/key_pair_factory.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class E2eKeyPairFactory implements KeyPairFactory {
  @override
  KeyPair create() => Sodium.cryptoKxKeypair();
}
