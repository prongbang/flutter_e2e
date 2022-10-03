import 'dart:typed_data';

import 'package:flutter_sodium/flutter_sodium.dart';

abstract class SharedKeyFactory {
  Uint8List create(KeyPair keyPair);
}
