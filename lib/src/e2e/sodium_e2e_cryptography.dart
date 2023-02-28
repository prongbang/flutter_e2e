import 'package:flutter_e2e/src/e2e/e2e_cryptography.dart';
import 'package:flutter_e2e/src/e2e/key/e2e_shared_key.dart';
import 'package:flutter_e2e/src/e2e/nonce/nonce_utility.dart';
import 'package:flutter_e2e/src/extensions/string_extension.dart';
import 'package:flutter_e2e/src/hex/hex.dart';

class SodiumE2eCryptography implements E2eCryptography {
  final E2eSharedKey e2eSharedKey;
  final NonceUtility nonceUtility;

  SodiumE2eCryptography(this.e2eSharedKey, this.nonceUtility);

  @override
  Future<String> decrypt(String cipherText) async {
    final noneHex = cipherText.substring(0, E2eCryptography.nonceLength);
    final nonce = await hex2bin(noneHex);
    final encryptedHex = cipherText.substring(E2eCryptography.nonceLength);
    final encrypted = await hex2bin(encryptedHex);

    final sharedKey = e2eSharedKey.sharedKey();
    final plainText = sharedKey.precalcBox?.openEasy(
      cipherText: encrypted,
      nonce: nonce,
    );
    if (plainText == null) return '';

    return String.fromCharCodes(plainText);
  }

  @override
  Future<String> encrypt(String plainText) async {
    final nonce = nonceUtility.random();
    final nonceHex = await bin2hex(nonce);

    final sharedKey = e2eSharedKey.sharedKey();
    final cipherBody = sharedKey.precalcBox?.easy(
      message: plainText.toUint8List(),
      nonce: nonce,
    );
    if (cipherBody == null) return '';

    final cipherHex = await bin2hex(cipherBody);

    return nonceHex + cipherHex;
  }
}
