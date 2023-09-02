import 'dart:typed_data';

import 'package:flutter_sodium/flutter_sodium.dart';

abstract class SessionKeyFactory {
  SessionKeys kxClientSessionKeys(
    KeyPair clientKeyPair,
    Uint8List serverPk,
  );

  SessionKeys kxServerSessionKeys(
    KeyPair serverKeyPair,
    Uint8List clientPk,
  );
}
