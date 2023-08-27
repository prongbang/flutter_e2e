import 'dart:typed_data';

import 'package:flutter_e2e/flutter_e2e.dart';
import 'package:flutter_e2e/src/e2e/key/shared_key.dart';
import 'package:flutter_e2e/src/e2e/key/sodium_key_pair.dart';
import 'package:flutter_e2e/src/e2e/nonce/nonce_utility.dart';
import 'package:flutter_e2e/src/e2e/nonce/sodium_nonce_utility.dart';
import 'package:flutter_e2e/src/extensions/string_extension.dart';
import 'package:flutter_e2e/src/platform/sodium_macos.dart' as sm;
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium_libs/sodium_libs.dart';

SharedKey _serverSharedKey = SharedKey();
SharedKey _clientSharedKey = SharedKey();

class ServerE2eSharedKey implements E2eSharedKey {
  @override
  SharedKey sharedKey() => _serverSharedKey;
}

class ClientE2eSharedKey implements E2eSharedKey {
  @override
  SharedKey sharedKey() => _clientSharedKey;
}

void main() {
  late Sodium sodium;
  late NonceUtility nonceUtility;
  late SharedKeyFactory sharedKeyFactory;
  late KeyPairFactory keyPairFactory;
  late E2eSharedKey serverE2eSharedKey;
  late E2eSharedKey clientE2eSharedKey;
  late E2eCryptography serverE2eCryptography;
  late E2eCryptography clientE2eCryptography;

  setUp(() async {
    sm.SodiumMacos.registerWith();
    sodium = await SodiumInit.init();
    keyPairFactory = E2eKeyPairFactory(sodium);
    sharedKeyFactory = E2eSharedKeyFactory(sodium);
    nonceUtility = SodiumNonceUtility(sodium);

    serverE2eSharedKey = ServerE2eSharedKey();
    clientE2eSharedKey = ClientE2eSharedKey();

    serverE2eCryptography = SodiumE2eCryptography(
      serverE2eSharedKey,
      nonceUtility,
    );
    clientE2eCryptography = SodiumE2eCryptography(
      clientE2eSharedKey,
      nonceUtility,
    );
  });

  test(
    'Should encrypt/decrypt success when encrypt and decrypt using XChaCha20Poly1305 algorithm',
    () async {
      // Given
      const message = 'End-to-End Encryption';

      // Key pair
      final serverKeyPair = keyPairFactory.create();
      final clientKeyPair = keyPairFactory.create();

      // https://libsodium.gitbook.io/doc/key_exchange
      // client_rx will be used by the client to receive data from the server,
      // client_tx will be used by the client to send data to the server.
      final clientSharedKeyPair = sodium.crypto.kx.clientSessionKeys(
        serverPublicKey: serverKeyPair.pk,
        clientSecretKey: clientKeyPair.sk,
        clientPublicKey: clientKeyPair.pk,
      );

      // server_rx will be used by the server to receive data from the client,
      // server_tx will be used by the server to send data to the client.
      final serverSharedKeyPair = sodium.crypto.kx.serverSessionKeys(
        serverPublicKey: serverKeyPair.pk,
        serverSecretKey: serverKeyPair.sk,
        clientPublicKey: clientKeyPair.pk,
      );

      // When

      // crypto_aead_xchacha20poly1305_ietf_encrypt
      // See https://libsodium.gitbook.io/doc/secret-key_cryptography/aead/chacha20-poly1305/xchacha20-poly1305_construction#combined-mode
      final nonce = nonceUtility.random();
      final encrypted = sodium.crypto.aead.encrypt(
        message: Uint8List.fromList(message.toIntList()),
        nonce: nonce,
        key: clientSharedKeyPair.tx,
      );

      // crypto_aead_xchacha20poly1305_ietf_decrypt
      // See https://libsodium.gitbook.io/doc/secret-key_cryptography/aead/chacha20-poly1305/xchacha20-poly1305_construction#combined-mode
      final decrypted = sodium.crypto.aead.decrypt(
        cipherText: encrypted,
        nonce: nonce,
        key: serverSharedKeyPair.rx,
      );
      final decryptedText = String.fromCharCodes(decrypted);

      // Then
      expect(decryptedText, message);
      expect(clientSharedKeyPair.rx.length, serverSharedKeyPair.rx.length);
      expect(clientSharedKeyPair.tx.length, serverSharedKeyPair.tx.length);
    },
  );

  test(
    'Should return cipher text and plain text when encrypt and decrypt success',
    () async {
      // Given
      const message = 'End-to-End Encryption';

      // Key pair
      final serverKeyPair = keyPairFactory.create();
      final clientKeyPair = keyPairFactory.create();

      // Key exchange
      final clientSharedKeyPair = sharedKeyFactory.create(SodiumKeyPair(
        pk: serverKeyPair.pk,
        sk: clientKeyPair.sk,
      ));
      final serverSharedKeyPair = sharedKeyFactory.create(SodiumKeyPair(
        pk: clientKeyPair.pk,
        sk: serverKeyPair.sk,
      ));

      // Save shared key to data store
      _serverSharedKey = serverSharedKeyPair;
      _clientSharedKey = clientSharedKeyPair;

      // When
      final cipherText = await clientE2eCryptography.encrypt(message);
      final plainText = await serverE2eCryptography.decrypt(cipherText);

      // Then
      expect(cipherText, isNotEmpty);
      expect(plainText, message);
    },
  );
}
