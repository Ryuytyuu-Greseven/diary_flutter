import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class ApiSettings {
  static const globalUrl = 'http://localhost:1999';
  static const enckey =
      r'#^&*NA#T)%!UR&E&*RY&$UYT/;YU^&U$@#NEXUS(SOCIAL$%KEY&)mindplay#%*^&@$89SPACE@#$93223%^&*(^';

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

  requestServer(body, String url) async {
    try {
      print('In Request');
      // encrypt data
      final encData = {'stinky': encrypt(body)};

      final response = await http.post(Uri.parse(url), body: encData);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        // Handle error scenarios
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error is: $error');
    }
  }

  encrypt(dataToEncrypt) {
    try {
      if (enckey.isNotEmpty) {
        final iv = IV.fromLength(16);
        final key = Key.fromUtf8(enckey);
        final plainText = jsonEncode(dataToEncrypt);
        final encrypter = Encrypter(AES(key));
        try {
          print('In Enc ${dataToEncrypt} ${plainText}');
          final encryptedText = encrypter.encrypt('test', iv: iv);
        } catch (e) {
          print('Exception ${e}');
        }
        final encryptedText = encrypter.encrypt('test');
        print('\n\nEncoded String ${encryptedText.toString()}');
        print('Decrypted data ${decrypt(encryptedText.toString())}');
        return encryptedText.toString();
      }
    } catch (error) {
      return;
    }
  }

  // decrypt data using nodejs crypto module
  decrypt(String dataToDecrypt) {
    try {
      print('In DEnc ${dataToDecrypt}');

      final key = Key.fromUtf8(enckey);
      final encrypter = Encrypter(AES(key));
      final encryptedData = Encrypted.fromUtf8(dataToDecrypt);
      final decrypted = encrypter.decrypt(encryptedData);
      final decryptedText = jsonDecode(decrypted);

      print('\n\nDecoded String ${decryptedText}');
      return decryptedText;
    } catch (error) {
      return false;
    }
  }
}
