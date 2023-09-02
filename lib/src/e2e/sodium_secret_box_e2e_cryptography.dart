import 'package:flutter_e2e/src/e2e/e2e_cryptography.dart';
import 'package:flutter_e2e/src/e2e/key/e2e_shared_key.dart';
import 'package:flutter_e2e/src/extensions/string_extension.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class SodiumSecretBoxE2eCryptography implements E2eCryptography {
  final E2eSharedKey e2eSharedKey;

  SodiumSecretBoxE2eCryptography(this.e2eSharedKey);

  @override
  Future<String> decrypt(String cipherText) async {
    final noneHex =
        cipherText.substring(0, Sodium.cryptoSecretboxNoncebytes * 2);
    final nonce = Sodium.hex2bin(noneHex);
    final encryptedHex =
        cipherText.substring(Sodium.cryptoSecretboxNoncebytes * 2);
    final encrypted = Sodium.hex2bin(encryptedHex);
    final plainText = Sodium.cryptoSecretboxOpenEasy(
      encrypted,
      nonce,
      e2eSharedKey.sharedKey(),
    );
    return String.fromCharCodes(plainText);
  }

  @override
  Future<String> encrypt(String plainText) async {
    final nonce = Sodium.randombytesBuf(Sodium.cryptoSecretboxNoncebytes);
    final encryptedBody = Sodium.cryptoSecretboxEasy(
      plainText.toUint8List(),
      nonce,
      e2eSharedKey.sharedKey(),
    );
    final encryptedHex = Sodium.bin2hex(encryptedBody);
    final nonceHex = Sodium.bin2hex(nonce);
    return nonceHex + encryptedHex;
  }
}
