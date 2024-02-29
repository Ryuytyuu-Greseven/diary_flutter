import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encryptService;
import 'package:pointycastle/export.dart';

class ApiSettings {
  final storage = const FlutterSecureStorage();

  // static const globalUrl = 'http://192.168.1.9:1999';
  static const globalUrl = 'https://rg-dairy.fly.dev';
  static const enckey =
      r'#^&*NA#T)%!UR&E&*RY&$UYT/;YU^&U$@#NEXUS(SOCIAL$%KEY&)mindplay#%*^&@$89SPACE@#$93223%^&*(^DIARY';

  static const Map<String, String> apis = {
    'LOGIN_USER': '$globalUrl/users/login',
    'SIGNUP_USER': '$globalUrl/users/signup',
    'VERIFY_USER': '$globalUrl/users/verify',
    'RESEND_OTP': '$globalUrl/users/resend_otp',

    'FETCH_USER_DETAILS': '$globalUrl/user/details',
    'CREATE_DAIRY': '$globalUrl/users/create',
    'FETCH_SELF_DAIRIES': '$globalUrl/users/self-dairies',
    'FETCH_DAIRY_DETAILS': '$globalUrl/users/dairy-details',
    'SAVE_PAGE': '$globalUrl/users/save-page',
    'DAIRY_PAGES': '$globalUrl/users/pages',

    // password reset
    'REQUEST_PASS_RESET': '$globalUrl/users/pass_reset',
  };

  requestServer(body, String url,context) async {
    try {
      print('In Request');
      // encrypt data
      final encData = {'shiny': jsonEncode(body)};
      print(encData);

      final token = await storage.read(key: 'auth_token');
      // if (token != null && token.isNotEmpty) {

      //   throw ErrorDescription('Access Denied!');
      // }
      final headers = {'Authorization': 'Bearer $token'};
      print(headers);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: encData);
      print(response);
      // Check if the request was successful (status code 200)
      if ([200, 201].contains(response.statusCode)) {
        print('Response body: ${response.body}');
      } else if ([401, 403].contains(response.statusCode)) {
        await storage.deleteAll();
        Navigator.pushNamed( context, '/login');
      } else {
        // Handle error scenarios
        print('Request failed with status: ${response.statusCode}');
      }
      final responseBody = json.decode(response.body);
      // print(responseBody);
      return responseBody;
    } catch (error) {
      // Handle network errors
      print('Error is: $error');
    }
  }

  encrypt(dataToEncrypt) {
    if (enckey.isNotEmpty) {
      try {
        final keyBytes = utf8.encode(enckey);
        final stringifyText = jsonEncode(dataToEncrypt);
        final plaintext = utf8.encode(stringifyText);

        final key = KeyParameter(keyBytes);
        // final iv = IV.fromLength(16);

        final blockCipher = BlockCipher('AES');
        print('Final');
        blockCipher.init(true, key);
        final paddedPlaintext = padBlock(plaintext);
        final ciphertext = blockCipher.process(paddedPlaintext);

        print('Encrypted text: ${base64.encode(ciphertext)}');
      } catch (e) {
        print('Encryption error: $e');
      }
    }
  }

  Uint8List padBlock(Uint8List data) {
    final paddingLength = 16 - (data.length % 16);
    final pad = List.filled(paddingLength, paddingLength.toUnsigned(8));
    final paddedData = Uint8List.fromList(data + pad);
    return paddedData;
  }

  decrypt(encryptedData) {
    try {
      final keyBytes = utf8.encode(enckey);
      final encryptedBytes = base64.decode(encryptedData);

      final key = KeyParameter(keyBytes);
      // final iv = IV.fromLength(16);

      final blockCipher = BlockCipher('AES');
      blockCipher.init(false, key); // false indicates for decryption

      final decrypted = blockCipher.process(encryptedBytes);

      final unpadData = unpadBlock(decrypted);
      final stringifyData = utf8.decode(unpadData);
      final dataDecrypted = jsonDecode(stringifyData);

      print('Decrypted text: ${dataDecrypted}');
    } catch (e) {
      print('Decryption error: $e');
    }
  }

  Uint8List unpadBlock(Uint8List data) {
    final lastByte = data.last;
    final padLength = lastByte.toInt();

    if (padLength <= 0 || padLength > 16) {
      throw Exception('Invalid padding length');
    }
    for (var i = data.length - padLength; i < data.length; i++) {
      if (data[i] != padLength) {
        throw Exception('Invalid padding');
      }
    }

    return data.sublist(0, data.length - padLength);
  }

  encryptOld(dataToEncrypt) {
    try {
      if (enckey.isNotEmpty) {
        final IOVI = encryptService.IV.fromUtf8(enckey);
        final key = encryptService.Key.fromUtf8(enckey);
        print(IOVI.base64);
        print(key.length);
        final plainText = jsonEncode(dataToEncrypt);
        final encrypter = encryptService.Encrypter(encryptService.AES(
          key,
          mode: encryptService.AESMode.cbc,
        ));
        try {
          print('In Enc ${dataToEncrypt} ${plainText}');
          print(enckey);
          final encryptedText = encrypter.encrypt('test', iv: IOVI);
        } catch (e) {
          print('Exception ${e}');
        }
        final encryptedText = encrypter.encrypt('test');
        print('\n\nEncoded String ${encryptedText.toString()}');
        print('Decrypted data ${decrypt(encryptedText.toString())}');
        return encryptedText.toString();
      }
    } catch (error) {
      print('Encryption Error: $error');
      return;
    }
  }

  // decrypt data using nodejs crypto module
  decryptOld(String dataToDecrypt) {
    try {
      print('In DEnc ${dataToDecrypt}');

      final key = encryptService.Key.fromUtf8(enckey);
      final encrypter = encryptService.Encrypter(encryptService.AES(key));
      final encryptedData = encryptService.Encrypted.fromUtf8(dataToDecrypt);
      final decrypted = encrypter.decrypt(encryptedData);
      final decryptedText = jsonDecode(decrypted);

      print('\n\nDecoded String ${decryptedText}');
      return decryptedText;
    } catch (error) {
      return false;
    }
  }
}
