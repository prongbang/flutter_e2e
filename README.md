# flutter_e2e

Flutter End-to-end encryption (E2EE) with flutter_sodium

## Usage

- pubspec.yml

```yaml
dependencies:
  flutter_e2e: ^1.0.1
```

### Create Key pair

```dart
final keyPairFactory = E2eKeyPairFactory();

final serverKeyPair = keyPairFactory.create();
final clientKeyPair = keyPairFactory.create();
```

### Key Exchange

```dart
final sharedKeyFactory = E2eSharedKeyFactory();
    
final clientSharedKeyPair = sharedKeyFactory.create(KeyPair(
    pk: serverKeyPair.pk,
    sk: clientKeyPair.sk,
));

final serverSharedKeyPair = sharedKeyFactory.create(KeyPair(
    pk: clientKeyPair.pk,
    sk: serverKeyPair.sk,
));

// Implement E2E Shared key & Store shared key
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

// Save shared key to data store
_serverSharedKey = serverSharedKeyPair;
_clientSharedKey = clientSharedKeyPair;
```

### Encrypt

```dart
final plainText = 'E2E';
final cipherText = await clientE2eCryptography.encrypt(plainText);
```

### Decrypt

```dart
final cipherText = 'HEX-STRING';
final plainText = await serverE2eCryptography.decrypt(cipherText);
```
