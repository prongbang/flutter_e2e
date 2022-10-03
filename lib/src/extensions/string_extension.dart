import 'dart:convert';
import 'dart:typed_data';

extension StringExtension on String? {
  List<int> toIntList() {
    return utf8.encode(this ?? '');
  }

  Uint8List toUint8List() {
    return Uint8List.fromList(toIntList());
  }
}
