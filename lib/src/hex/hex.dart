import 'package:flutter/foundation.dart';

Future<String> bin2hex(Uint8List bytes) {
  return compute(_bin2hex, bytes);
}

Future<Uint8List> hex2bin(String input) {
  return compute(_hex2bin, input);
}

String _bin2hex(List<int> bin) {
  var buffer = "";
  for (var b in bin) {
    buffer += (b + 0x100).toRadixString(16).substring(1);
  }
  return buffer;
}

Uint8List _hex2bin(String input) {
  var bytes = List.filled((input.length / 2).round(), 0, growable: true);
  for (var i = 0; i < input.length; i += 2) {
    bytes[(i / 2).round()] = int.parse(input.substring(i, i + 2), radix: 16);
  }
  return Uint8List.fromList(bytes);
}
