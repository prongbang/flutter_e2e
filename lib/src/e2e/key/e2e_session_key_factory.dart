import 'dart:typed_data';

import 'package:flutter_e2e/src/e2e/key/session_key_factory.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class E2eSessionKeyFactory implements SessionKeyFactory {
  @override
  SessionKeys kxClientSessionKeys(KeyPair clientKeyPair, Uint8List serverPk) =>
      KeyExchange.computeClientSessionKeys(clientKeyPair, serverPk);

  @override
  SessionKeys kxServerSessionKeys(KeyPair serverKeyPair, Uint8List clientPk) =>
      KeyExchange.computeServerSessionKeys(serverKeyPair, clientPk);
}
