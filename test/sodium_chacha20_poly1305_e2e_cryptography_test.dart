
import 'dart:typed_data';

import 'package:flutter_e2e/flutter_e2e.dart';
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List _serverSharedKey = Uint8List(0);
Uint8List _clientSharedKey = Uint8List(0);

class ServerE2eSharedKey implements E2eSharedKey {
  @override
  Uint8List sharedKey() => _serverSharedKey;
}

class ClientE2eSharedKey implements E2eSharedKey {
  @override
  Uint8List sharedKey() => _clientSharedKey;
}

void main() {
  late SharedKeyFactory sharedKeyFactory;
  late KeyPairFactory keyPairFactory;

  late E2eSharedKey serverE2eSharedKey;
  late E2eSharedKey clientE2eSharedKey;

  late E2eCryptography serverE2eCryptography;
  late E2eCryptography clientE2eCryptography;

  setUp(() {
    keyPairFactory = E2eKeyPairFactory();
    sharedKeyFactory = E2eSharedKeyFactory();

    serverE2eSharedKey = ServerE2eSharedKey();
    clientE2eSharedKey = ClientE2eSharedKey();

    serverE2eCryptography = SodiumChaCha20Poly1305E2eCryptography(serverE2eSharedKey);
    clientE2eCryptography = SodiumChaCha20Poly1305E2eCryptography(clientE2eSharedKey);
  });

  test(
    'Should return cipher text and plain text when encrypt and decrypt success',
        () async {
      // Given
      const message = 'End-to-End Encryption';

      // Key pair
      final serverKeyPair = keyPairFactory.create();
      final clientKeyPair = keyPairFactory.create();

      // Key exchange
      final clientSharedKeyPair = sharedKeyFactory.create(KeyPair(
        pk: serverKeyPair.pk,
        sk: clientKeyPair.sk,
      ));
      final serverSharedKeyPair = sharedKeyFactory.create(KeyPair(
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
      expect(clientSharedKeyPair, serverSharedKeyPair);
      expect(
        Sodium.bin2hex(clientSharedKeyPair),
        Sodium.bin2hex(serverSharedKeyPair),
      );
    },
  );
}