import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;


class Loginprovider extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();

  // Future<bool> loginwithphone(String phone, BuildContext context) async {
  //   print(phone);
  //   String url = "${Constants.baseUrl}/api/v1/patient/loginphone";
  //   // '${Constants.baseUrl}/app/log-in/phone-otp'
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'phone': phone,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print(responseData);
  //       Constants.phone = phone;

  //       final sucessSnackbar = SnackBar(
  //           backgroundColor: Colors.green[400],
  //           content: Text(
  //             'OTP sent sucessfully',
  //             style: TextStyle(color: Colors.grey[50]),
  //           ));

  //       ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
  //       return true;
  //       // context.router.popAndPush(OtpVerificationRoute());
  //     } else {
  //       final responseData = jsonDecode(response.body);
  //       final snackbar = SnackBar(
  //           backgroundColor: Colors.red[400],
  //           content: Text(
  //             responseData['msg'],
  //             style: TextStyle(color: Colors.white),
  //           ));
  //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e);
  //     final error = SnackBar(
  //         backgroundColor: Colors.red[400], content: Text(e.toString()));
  //     ScaffoldMessenger.of(context).showSnackBar(error);
  //     return false;
  //   }
  // }

  Future<bool> loginphone(String phone, BuildContext context) async {
    print(phone);
    String url = "${Constants.baseUrl}/api/v1/patient/login";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        Constants.phone = phone;
        print(responseData['token']);
        await secureStorage.writeSecureData('token', responseData['token']);
        await secureStorage.readSecureData('token').then((value) {
          Constants.token = value;
        });

        print("Constants.token ${Constants.token}");

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Logged in sucessfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        return true;
        // context.router.popAndPush(OtpVerificationRoute());
      } else {
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.white),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return false;
      }
    } catch (e) {
      print(e);
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      return false;
    }
  }

  Future<bool> doctorloginphone(String userid, String password, BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/loginphone";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userid': userid,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['token']);
        await secureStorage.writeSecureData('doctortoken', responseData['token']);
        await secureStorage.readSecureData('doctortoken').then((value) {
          Constants.doctortoken = value;
        });

        print("Constants.doctortoken ${Constants.doctortoken}");

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Logged in sucessfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        return true;
        // context.router.popAndPush(OtpVerificationRoute());
      } else {
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.white),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return false;
      }
    } catch (e) {
      print(e);
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      return false;
    }
  }
  Future<bool> adminloginphone(String userid, String password, BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/loginphone";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userid': userid,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        
        print(responseData['token']);
        await secureStorage.writeSecureData('admintoken', responseData['token']);
        await secureStorage.readSecureData('admintoken').then((value) {
          Constants.admintoken = value;
        });

        print("Constants.admintoken ${Constants.admintoken}");

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Logged in sucessfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        return true;
        // context.router.popAndPush(OtpVerificationRoute());
      } else {
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.white),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return false;
      }
    } catch (e) {
      print(e);
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      return false;
    }
  }
  Future<bool> supportingstaffloginphone(String userid, String password, BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/loginphone";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
       body: jsonEncode(<String, dynamic>{
          'userid': userid,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        print(responseData['token']);
        await secureStorage.writeSecureData('nursetoken', responseData['token']);
        await secureStorage.readSecureData('nursetoken').then((value) {
          Constants.nursetoken = value;
        });

        print("Constants.nursetoken ${Constants.nursetoken}");

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Logged in sucessfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        return true;
        // context.router.popAndPush(OtpVerificationRoute());
      } else {
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.white),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return false;
      }
    } catch (e) {
      print(e);
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      return false;
    }
  }

  // Future<void> resendOtp(String phone, BuildContext context) async {
  //   print(phone);
  //   String url = "${Constants.baseUrl}/api/v1/patient/loginphone";
  //   // '${Constants.baseUrl}/app/log-in/phone-otp'
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'phone': phone,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print(responseData);
  //       Constants.phone = phone;
  //       // secureStorage.writeSecureData('phone', responseData['token']);
  //       // secureStorage.readSecureData('token').then((value) {
  //       //   Constants.token = value;
  //       // });
  //       // secureStorage.writeSecureData('phone', input);
  //       // secureStorage.readSecureData('phone').then((value) {
  //       //   Constants.email = value;
  //       // });

  //       final sucessSnackbar = SnackBar(
  //           backgroundColor: Colors.green[400],
  //           content: Text(
  //             'OTP sent sucessfully',
  //             style: TextStyle(color: Colors.grey[50]),
  //           ));

  //       ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
  //       // context.router.popAndPush(OtpVerificationRoute());
  //     } else if (response.statusCode == 503) {
  //       final snackbar = SnackBar(
  //           backgroundColor: Colors.red[400],
  //           content: Text('User Does not exist'));
  //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //     } else {
  //       // result = '';

  //       // If the server returns an error response, throw an exception
  //       throw Exception('${response.body}');
  //     }
  //   } catch (e) {
  //     final error = SnackBar(
  //         backgroundColor: Colors.red[400], content: Text(e.toString()));
  //     ScaffoldMessenger.of(context).showSnackBar(error);
  //   }
  // }

  // Future<void> verifyphoneOtp(
  //     String phone, String otp, BuildContext context) async {
  //   String url = "${Constants.baseUrl}/api/v1/patient/verifyotp";
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'phone': phone,
  //         'otp': otp,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // Successful POST request, handle the response here
  //       final responseData = jsonDecode(response.body);
  //       print(responseData);
  //       print(responseData['token']);
  //       await secureStorage.writeSecureData('token', responseData['token']);
  //       await secureStorage.readSecureData('token').then((value) {
  //         Constants.token = value;
  //       });

  //       print("Constants.token ${Constants.token}");

  //       final sucessSnackbar = SnackBar(
  //           backgroundColor: Colors.green[400],
  //           content: Text(
  //             responseData['msg'],
  //             style: TextStyle(color: Colors.grey[50]),
  //           ));

  //       ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
  //       Constants.otpverification = true;
  //       // context.router.popAndPush(HomeNewRoute());

  //       context.router.replaceAll([HomeRoute()]);

  //       context.router.popUntilRoot();
  //       notifyListeners();
  //     } else {
  //       final responseData = jsonDecode(response.body);
  //       final snackbar = SnackBar(
  //           backgroundColor: Colors.red[400],
  //           content: Text(responseData['msg'],
  //               style: TextStyle(color: Colors.grey[50])));
  //       Constants.otpverification = false;
  //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //     }
  //     //  else {
  //     //   // result = '';

  //     //   // If the server returns an error response, throw an exception
  //     //   Constants.otpverification = false;
  //     //   throw Exception(response.body);
  //     // }
  //   } catch (e) {
  //     final error = SnackBar(content: Text(e.toString()));
  //     ScaffoldMessenger.of(context).showSnackBar(error);
  //   }
  // }
}
