// import 'dart:io';
// import 'package:hospital_mobile_app/service/constant.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SttService {
//   Future<Map<String, dynamic>> transcribeAudio(String filePath) async {
//     print('filePath: $filePath');
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/voice-prescription'),
//     );

//     request.headers['Authorization'] = 'Bearer ${Constants.doctortoken}';

//     request.files.add(
//       await http.MultipartFile.fromPath('file', filePath),
//     );

//     final streamed = await request.send();
//     final response = await http.Response.fromStream(streamed);
//     print(response.body);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     } else if (response.statusCode == 401) {
//       throw Exception('UNAUTHORIZED');
//     } else {
//       throw Exception('STT API error ${response.statusCode}: ${response.body}');
//     }
//   }
// }



import 'dart:io';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SttService {
    final SecureStorage secureStorage = SecureStorage();

 
  Future<Map<String, dynamic>> transcribeAudio(String filePath) async {
    print('filePath: $filePath');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/voice-prescription'),
    );

    request.headers['Authorization'] = 'Bearer ${Constants.doctortoken}';

    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );

    try {
      // Give the client a bit more headroom than Cloudflare's 100s,
      // so we surface OUR message instead of a raw connection drop.
      final streamed = await request.send().timeout(
        const Duration(seconds: 110),
        onTimeout: () {
          throw TimeoutException('STT request timed out on the client');
        },
      );
      final response = await http.Response.fromStream(streamed);
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
       refreshtoken();
try {
      // Give the client a bit more headroom than Cloudflare's 100s,
      // so we surface OUR message instead of a raw connection drop.
      final streamed = await request.send().timeout(
        const Duration(seconds: 110),
        onTimeout: () {
          throw TimeoutException('STT request timed out on the client');
        },
      );
      final response = await http.Response.fromStream(streamed);
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
      throw Exception(response);

      } else if (response.statusCode == 524 || response.statusCode == 522 || response.statusCode == 504) {
        // Cloudflare/gateway timeout — the server likely just took too long,
        // it may still be processing. Treat distinctly from a hard failure.
        throw Exception(
          'TIMEOUT: The analysis is taking longer than expected. '
          'Please try again with a shorter recording, or try again in a moment.',
        );
      } else {
        throw Exception('STT API error ${response.statusCode}: ${response.body}');
      }
    } on TimeoutException {
      throw Exception(
        'TIMEOUT: The analysis is taking longer than expected. '
        'Please try again with a shorter recording, or try again in a moment.',
      );
    } on SocketException {
      throw Exception('NETWORK: Could not reach the server. Check your connection.');
    }
      } else if (response.statusCode == 524 || response.statusCode == 522 || response.statusCode == 504) {
        // Cloudflare/gateway timeout — the server likely just took too long,
        // it may still be processing. Treat distinctly from a hard failure.
        throw Exception(
          'TIMEOUT: The analysis is taking longer than expected. '
          'Please try again with a shorter recording, or try again in a moment.',
        );
      } else {
        throw Exception('STT API error ${response.statusCode}: ${response.body}');
      }
    } on TimeoutException {
      throw Exception(
        'TIMEOUT: The analysis is taking longer than expected. '
        'Please try again with a shorter recording, or try again in a moment.',
      );
    } on SocketException {
      throw Exception('NETWORK: Could not reach the server. Check your connection.');
    }
  }

  Future<void> refreshtoken() async {
    try {
      print("Refresh token is called here");
      Constants.doctorrefreshtoken = await secureStorage.readSecureData('doctorrefreshtoken') ?? '';

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/refreshtokendoctoradminmobile'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.doctorrefreshtoken}',
          'Content-Type': 'application/json',
          // ...headers,
        },
      );

      if (response.statusCode == 200) {
       print(response.body);
        final responseData = jsonDecode(response.body);
await secureStorage.writeSecureData('doctortoken', responseData['token']);
        await secureStorage.writeSecureData('doctorrefreshtoken', responseData['refreshToken']);
        await secureStorage.readSecureData('doctortoken').then((value) {
          Constants.doctortoken = value;
        });

  await secureStorage.readSecureData('doctorrefreshtoken').then((value) {
          Constants.doctorrefreshtoken = value;
        });
        print("Constants.doctortoken ${Constants.doctortoken}");
        print("Constants.doctorrefreshtoken ${Constants.doctorrefreshtoken}");


        // notifyListeners();
      } 
      else if (response.statusCode == 401) {
        await secureStorage.deleteSecureData('doctortoken');
        await secureStorage.deleteSecureData('doctorrefreshtoken');
      
        Constants.doctortoken = '';
        Constants.doctorrefreshtoken = '';
        // logout();
        // if (context.mounted) context.router.popAndPush(SplashRoute());
        // notifyListeners();
      }
      else if(response.statusCode == 403 ){
        await secureStorage.deleteSecureData('doctortoken');
        await secureStorage.deleteSecureData('doctorrefreshtoken');
      
        Constants.doctortoken = '';
        Constants.doctorrefreshtoken = '';
        // logout();
        // if (context.mounted) context.router.popAndPush(SplashRoute());
      }
       else {
        print(
            "Refresh failed with status: ${response.statusCode} — ${response.body}");
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
    }
  }
}