import 'package:flutter_e2e/flutter_e2e.dart';
import 'package:flutter_e2e/src/e2e/key/shared_key.dart';
import 'package:flutter_e2e/src/e2e/key/sodium_key_pair.dart';
import 'package:flutter_e2e/src/e2e/nonce/nonce_utility.dart';
import 'package:flutter_e2e/src/e2e/nonce/sodium_nonce_utility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium_libs/sodium_libs.dart';
import 'package:sodium_libs/src/platforms/sodium_macos.dart';

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
    SodiumMacos.registerWith();
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
      expect(clientSharedKeyPair, serverSharedKeyPair);
    },
  );
}
