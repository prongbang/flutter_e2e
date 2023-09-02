import 'package:flutter_e2e/flutter_e2e.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class SodiumChaCha20Poly1305E2eCryptography implements E2eCryptography {
  final E2eSharedKey e2eSharedKey;

  SodiumChaCha20Poly1305E2eCryptography(this.e2eSharedKey);

  @override
  Future<String> decrypt(String cipherText) async {
    final noneHex =
        cipherText.substring(0, Sodium.cryptoAeadChacha20poly1305Npubbytes * 2);
    final nonce = Sodium.hex2bin(noneHex);
    final encryptedHex =
        cipherText.substring(Sodium.cryptoAeadChacha20poly1305Npubbytes * 2);
    final encrypted = Sodium.hex2bin(encryptedHex);
    final plainText = ChaCha20Poly1305.decryptString(
      encrypted,
      nonce,
      e2eSharedKey.sharedKey(),
    );
    return plainText;
  }

  @override
  Future<String> encrypt(String plainText) async {
    final nonce = ChaCha20Poly1305.randomNonce();
    final encryptedBody = ChaCha20Poly1305.encryptString(
      plainText,
      nonce,
      e2eSharedKey.sharedKey(),
    );
    final encryptedHex = Sodium.bin2hex(encryptedBody);
    final nonceHex = Sodium.bin2hex(nonce);
    return nonceHex + encryptedHex;
  }
}
