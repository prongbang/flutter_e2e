import 'package:flutter_e2e/flutter_e2e.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class SodiumXChaCha20Poly1305IetfE2eCryptography implements E2eCryptography {
  final E2eSharedKey e2eSharedKey;

  SodiumXChaCha20Poly1305IetfE2eCryptography(this.e2eSharedKey);

  @override
  Future<String> decrypt(String cipherText) async {
    final noneHex = cipherText.substring(
        0, Sodium.cryptoAeadXchacha20poly1305IetfNpubbytes * 2);
    final nonce = Sodium.hex2bin(noneHex);
    final encryptedHex = cipherText
        .substring(Sodium.cryptoAeadXchacha20poly1305IetfNpubbytes * 2);
    final encrypted = Sodium.hex2bin(encryptedHex);
    final plainText = XChaCha20Poly1305Ietf.decryptString(
      encrypted,
      nonce,
      e2eSharedKey.sharedKey(),
    );
    return plainText;
  }

  @override
  Future<String> encrypt(String plainText) async {
    final nonce = XChaCha20Poly1305Ietf.randomNonce();
    final encryptedBody = XChaCha20Poly1305Ietf.encryptString(
      plainText,
      nonce,
      e2eSharedKey.sharedKey(),
    );
    final encryptedHex = Sodium.bin2hex(encryptedBody);
    final nonceHex = Sodium.bin2hex(nonce);
    return nonceHex + encryptedHex;
  }
}
