abstract class E2eCryptography {
  static const int nonceLength = 48;

  Future<String> encrypt(String plainText);

  Future<String> decrypt(String cipherText);
}
