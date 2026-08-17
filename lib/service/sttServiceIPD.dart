// import 'dart:io';
// import 'package:hospital_mobile_app/service/constant.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SttServiceIPD {
//   Future<Map<String, dynamic>> transcribeAudio(String filePath) async {
//     print('filePath: $filePath');
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/inpatient-voice-prescription'),
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
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SttServiceIPD {
  Future<Map<String, dynamic>> transcribeAudio(String filePath) async {
    print('filePath: $filePath');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/inpatient-voice-prescription'),
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
        throw Exception('UNAUTHORIZED');
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
}