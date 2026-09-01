// import 'dart:convert';
// import 'dart:io';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:hospital_mobile_app/routes/app_router.dart';
// import 'package:hospital_mobile_app/service/cacheManager.dart';
// import 'package:hospital_mobile_app/service/constant.dart';
// import 'package:hospital_mobile_app/service/deviceHeader.dart';
// import 'package:hospital_mobile_app/service/secure_storage.dart';
// import 'package:http/http.dart' as http;


// class Doctorprovider extends ChangeNotifier {
//     List<Map<String, dynamic>> doctordetailedprofile = [];
//     List<Map<String, dynamic>> patients = [];
//     List<Map<String, dynamic>> filteredPatients = [];
//     List<Map<String, dynamic>> allpatients = [];
//     List<Map<String, dynamic>> patientdetails = [];
//     List<Map<String, dynamic>> patientinvisits = [];
//     List<Map<String, dynamic>> patientoutvisits = [];
//     List<Map<String, dynamic>> alldoctors = [];
//     List<Map<String, dynamic>> allnurses = [];
//     List<Map<String, dynamic>> gettodaysvisits = [];
//     List<Map<String, dynamic>> filteredvisits = [];
//     List<Map<String, dynamic>> activeinvisits = [];
//     List<Map<String, dynamic>> filteredactiveinvisits = [];
//     List<Map<String, dynamic>> patientdiagnosis = [];
//     List<Map<String, dynamic>> patientalldiagnosis = [];
//     List<Map<String, dynamic>> importpatientalldiagnosis = [];
//     List<Map<String, dynamic>> patientallobservations = [];
//     List<dynamic> outvisitsupportingfiles = [];
//     List<dynamic> invisitsupportingfiles = [];
//     List<Map<String, dynamic>> allsharedpatients = [];
//     List<Map<String, dynamic>> filteredallsharedpatients = [];
//     List<Map<String, dynamic>> sharedpatientinvisits = [];
//     List<Map<String, dynamic>> sharedpatientoutvisits = [];

//   final CacheManager _cache = CacheManager();


//   final String kPatients = 'patients';
//   final String kProfile  = 'profile';
//   final String Invisits = 'invisits';
//   final String Outvisits = 'outvisits';
//   final String PatientInvisits = 'patientinvisits';
//   final String PatientOutvisits = 'patientoutvisits';

//     String invisitId = '';
//     bool isDeleting = false;
//     bool isSavingOutdisagnosis = false;
//     bool isSavingIndiagnosis = false;
//     bool addinginvisit = false;
//     bool addingoutvisit = false;  
//     bool addingpatient = false;
//     bool editingpatient = false;

//        String patienthistorydata = "";
// String inpatienthistorydata = "";


//   final SecureStorage secureStorage = SecureStorage();


//   Future<void> getdoctordetailedprofile(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getmydetailprofile";

//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
    
//     try {
//       final cached = _cache.get<List<Map<String, dynamic>>>(kProfile);
//       // if (_cache.isCacheValid(kProfile)) return;
//        if (cached != null) {
//         doctordetailedprofile = cached;
//         notifyListeners();
//         return;
//       }
      
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['myprofile'];

//         if (data is List) {
//           doctordetailedprofile = List<Map<String, dynamic>>.from(data);
          


//           notifyListeners();
//         } else if (data is Map) {
//           doctordetailedprofile = [Map<String, dynamic>.from(data)];
//           print('doctor details : $doctordetailedprofile');
//           // print(doctordetailedprofile);
//         }
//         _cache.set(kProfile, doctordetailedprofile);
//         notifyListeners();
//       } else if(response.statusCode == 401){
//        await refreshtoken(context);
//        Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//        try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['myprofile'];

//         if (data is List) {
//           doctordetailedprofile = List<Map<String, dynamic>>.from(data);
          
//           notifyListeners();
//         } else if (data is Map) {
//           doctordetailedprofile = [Map<String, dynamic>.from(data)];
//           print('doctor details : $doctordetailedprofile');
//           // print(doctordetailedprofile);
//         }
//         _cache.set(kProfile, doctordetailedprofile);

//         notifyListeners();
//       } 
//        else {
//         print('${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//       } else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }

//        else {
//         print('${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }



// Future<void> getpatientbydoctor(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor";

//     Constants.token = await secureStorage.readSecureData('doctortoken') ?? '';
    
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         patients =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//             print(patients);

//         notifyListeners();
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
//          Constants.token = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         patients =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//  print(patients);
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         print('No patients found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
      
//        else if (response.statusCode == 404) {
//         print('No patients found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }


// Future<void> getPatientsByPageWithSearch(int page, String searchQuery, BuildContext context) async {
//   final String url = searchQuery.isNotEmpty 
//       ? "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor?page=$page&search=${Uri.encodeComponent(searchQuery)}"
//       : "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor?page=$page";

//   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//   try {
// // if (page == 1 && searchQuery.isEmpty && _cache.isCacheValid(kPatients)) {
// //       return; // ← Serve from cache, skip API
// //     }

//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

//       // Get new patients from response
//       List<Map<String, dynamic>> newPatients = json.decode(response.body)['data'].cast<Map<String, dynamic>>();
// print(newPatients);
//       if (page == 1) {
//         // First page or new search - replace existing data
//         allpatients = newPatients;
//         filteredPatients = [...allpatients];
//       } else {
//         // Subsequent pages - append data
//         allpatients.addAll(newPatients);
//         filteredPatients = [...allpatients];
//       }
      
//       //   if (page == 1 && searchQuery.isEmpty) {
//       //   _cache.markCached(kPatients); // ← Mark as cached after success
//       // }

//       notifyListeners();
//     } 
//     else if(response.statusCode == 401){
//       await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

//       // Get new patients from response
//       List<Map<String, dynamic>> newPatients = json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//       if (page == 1) {
//         // First page or new search - replace existing data
//         allpatients = newPatients;
//         filteredPatients = [...allpatients];
//       } else {
//         // Subsequent pages - append data
//         allpatients.addAll(newPatients);
//         filteredPatients = [...allpatients];
//       }
      
//       notifyListeners();
//     } else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
    
//      else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
// }

// Future<void> getPatientsByPage(int page, BuildContext context) async {
//   await getPatientsByPageWithSearch(page, '', context);
// }

//   Future<void> addpatient(String name, String phone, String gender,
//       String email, String dob, BuildContext context) async {
//     try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "phone": phone,
//         "DOB": dob,
//       };

//       if (email.isNotEmpty) {
//         requestBody["email"] = email;
//       }

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addpatient'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingpatient = false;
//         print(responseData);
//         invalidateCache(key: kPatients);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         _cache.invalidateAll();
//         getPatientsByPage(1, context);
//         Navigator.pop(context);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "phone": phone,
//         "DOB": dob,
//       };

//       if (email.isNotEmpty) {
//         requestBody["email"] = email;
//       }

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addpatient'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingpatient = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getPatientsByPage(1, context);
//         Navigator.pop(context);
//       } else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addingpatient = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addingpatient = false;
//       notifyListeners();
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addingpatient = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addingpatient = false;
//       notifyListeners();
//     }
//   }

//   Future<void> getpatient(String id, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbyid/$id";
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['data'];
//         if (data is List) {
//           patientdetails = List<Map<String, dynamic>>.from(data);
//           notifyListeners();
//         } else if (data is Map) {
//           patientdetails = [Map<String, dynamic>.from(data)];
//           // print(patientdetails);
//           notifyListeners();
//         }
//         notifyListeners();
//         // print(patientdetails);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['data'];
//         if (data is List) {
//           patientdetails = List<Map<String, dynamic>>.from(data);
//           notifyListeners();
//         } else if (data is Map) {
//           patientdetails = [Map<String, dynamic>.from(data)];
//           // print(patientdetails);
//           notifyListeners();
//         }
//         notifyListeners();
//         // print(patientdetails);
//       } else {
//         print('${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print('${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> editpatient(String id, String name, String dob, String gender,
//       String email, String phone, BuildContext context) async {
//     try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       print(
//           "name: $name gender: $gender DOB: $dob email: $email phone: $phone");

//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "DOB": dob,
//         "email": email,
//         "phone": phone
//       };

//       // if (phone.isNotEmpty) {
//       //   requestBody["memberphone"] = phone;
//       // }

//       // if (email.isNotEmpty) {
//       //   requestBody["email"] = email;
//       // }

//       String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/editpatient/$id";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         editingpatient = false;
//         invalidateCache(key: kPatients);
//         await getpatient(id, context);

//         notifyListeners();
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Patient details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         getPatientsByPage(1, context);
//         // getallpatients();
//         Navigator.pop(context);

//         notifyListeners();
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
//         try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       print(
//           "name: $name gender: $gender DOB: $dob email: $email phone: $phone");

//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "DOB": dob,
//         "email": email,
//         "phone": phone
//       };

//       String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/editpatient/$id";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         editingpatient = false;
//         await getpatient(id, context);

//         notifyListeners();
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Patient details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         getPatientsByPage(1, context);
//         // getallpatients();
//         Navigator.pop(context);

//         notifyListeners();
//       } else {
//         final responseData = jsonDecode(response.body);
//         editingpatient = false;
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       editingpatient = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         final responseData = jsonDecode(response.body);
//         editingpatient = false;
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       editingpatient = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }


// Future<void> getpatientinvisits(String id, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getinvisit/$id";
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       // if (_cache.isCacheValid(PatientInvisits)) return;
//       // final cached = _cache.get<List<Map<String, dynamic>>>(PatientInvisits);
//       // if (cached != null) {
//       //   patientinvisits = cached;
//       //   notifyListeners();
//       //   return;
//       // }
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );
//       print(response);

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientinvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//             //  _cache.markCached(PatientInvisits);
//             // _cache.set(PatientInvisits, patientinvisits);
//         notifyListeners();
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientinvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
// // _cache.markCached(PatientInvisits);
//                     // _cache.set(PatientInvisits, patientinvisits);

//         notifyListeners();

//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getpatientoutvisits(String id, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getoutvisit/$id";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       // if (_cache.isCacheValid(PatientOutvisits)) return;
//       // final cached = _cache.get<List<Map<String, dynamic>>>(PatientOutvisits);
//       // if (cached != null) {
//       //   patientoutvisits = cached;
//       //   notifyListeners();
//       //   return;
//       // }
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientoutvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//             // _cache.set(PatientOutvisits, patientoutvisits);
//             //  _cache.markCached(PatientOutvisits);
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientoutvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
// // _cache.markCached(PatientOutvisits);
//                     // _cache.set(PatientOutvisits, patientoutvisits);

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       } 
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//       else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }


// Future<void> addoutvisit(
//       String patientId,
//       String Chiefcomplaint,
//       String height,
//       String weight,
//       String bp,
//       String temperature,
//       String heartrate,
//       List<Map<String, dynamic>> vitals,
//       BuildContext context) async {
//     try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//       };

//       if (height.isNotEmpty) {
//         requestBody["height"] = height;
//       }
//       if (weight.isNotEmpty) {
//         requestBody["weight"] = weight;
//       }
//       if (bp.isNotEmpty) {
//         requestBody["bp"] = bp;
//       }
//       if (heartrate.isNotEmpty) {
//         requestBody["heart_rate"] = heartrate;
//       }
//       if (temperature.isNotEmpty) {
//         requestBody["temperature"] = temperature;
//       }

//       if (vitals.isNotEmpty) requestBody["vitals"] = vitals;
      
//       print(requestBody);

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addoutvisit/$patientId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//          addingoutvisit = false;
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Out Visit added successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         invalidateCache(key: PatientOutvisits);

//         getpatientoutvisits(patientId, context);

//         notifyListeners();

//         Navigator.pop(context);
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
//         try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//       };

//       if (height.isNotEmpty) {
//         requestBody["height"] = height;
//       }
//       if (weight.isNotEmpty) {
//         requestBody["weight"] = weight;
//       }
//       if (bp.isNotEmpty) {
//         requestBody["bp"] = bp;
//       }
//       if (heartrate.isNotEmpty) {
//         requestBody["heart_rate"] = heartrate;
//       }
//       if (temperature.isNotEmpty) {
//         requestBody["temperature"] = temperature;
//       }
// if (vitals.isNotEmpty) requestBody["vitals"] = vitals;

//       print(requestBody);

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addoutvisit/$patientId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//          addingoutvisit = false;
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Out Visit added successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

//         getpatientoutvisits(patientId, context);

//         notifyListeners();

//         Navigator.pop(context);
//       } else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addingoutvisit = false;
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addingoutvisit = false;
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addingoutvisit = false;
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addingoutvisit = false;
//     }
//   }

  

//   Future<void> adddiagnosis(
//     String patientId,
//     String complaintId,
//     String diagnosis,
//     String medicaladvice,
//     String labtest,
//     String doctorremark,
//     String followupdate,
//     List<Map<String, dynamic>> medication,
//     List<File> supportingfiles,
//     BuildContext context,
//   ) async {
//           Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//     var url = Uri.parse(
//         '${Constants.baseUrl}/api/v1/hospitaldoctor/addoutdiagnosis/$patientId/$complaintId');

//     var request = http.MultipartRequest('POST', url);

//     request.headers['Authorization'] = 'Bearer ${Constants.doctortoken}';

//     // Add form-data fields
//     request.fields['diagnosis_summary'] = diagnosis;

//     if (medicaladvice.isNotEmpty) {
//       request.fields["medical_advice"] = medicaladvice;
//     }

//     if (labtest.isNotEmpty) {
//       request.fields["lab_test"] = labtest;
//     }
//     if (doctorremark.isNotEmpty) {
//       request.fields["doctors_remark"] = doctorremark;
//     }
//     if (followupdate.isNotEmpty) {
//       request.fields["followup_date"] = followupdate;
//     }

//     if (supportingfiles.isNotEmpty) {
//       for (var file in supportingfiles) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'attachments', // this name must match `req.files` in Node.js multer setup
//           file.path,
//         ));
//       }
//     }

//     if (medication.isNotEmpty && medication[0]["medicine"] != "") {
//       // formData["medication"] =
//       //     jsonEncode(medication); // Convert List to JSON String
//       request.fields['medication'] = jsonEncode(medication);
//     } else {
//       request.fields['medication'] = '[]'; // Send empty list as string
//     }

//     print(request.fields);
//     print("Files being sent:");
//     for (var f in request.files) {
//       print("Field: ${f.field}, filename: ${f.filename}");
//     }
//     // Send as empty list in string form

//     try {
//       // Send the request
//       var streamedResponse = await request.send();

//       // Convert to standard response
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//          isSavingOutdisagnosis = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         invalidateCache();
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Diagnosis added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientoutvisits(patientId, context);
// gettodaysoutvisits(context);
// notifyListeners();
//         Navigator.pop(context);
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
// Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       // Send the request
//       var streamedResponse = await request.send();

//       // Convert to standard response
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//          isSavingOutdisagnosis = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Diagnosis added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientoutvisits(patientId, context);
//         Navigator.pop(context);
//       } else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//          isSavingOutdisagnosis = false;
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//            isSavingOutdisagnosis = false;
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
      
//       else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//          isSavingOutdisagnosis = false;
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//            isSavingOutdisagnosis = false;
//     }
//   }

// Future<void> getdoctorsnurses(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getalldoctorsnurses";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//         alldoctors =
//             json.decode(response.body)['doctors'].cast<Map<String, dynamic>>();
//             allnurses = json.decode(response.body)['nurses'].cast<Map<String, dynamic>>();
//             print('alldoctors $alldoctors');
//             print('allnurses $allnurses');
//         notifyListeners();
//       } else if(response.statusCode == 401 ){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//         alldoctors =
//             json.decode(response.body)['doctors'].cast<Map<String, dynamic>>();
//             allnurses = json.decode(response.body)['nurses'].cast<Map<String, dynamic>>();
//             print('alldoctors $alldoctors');
//             print('allnurses $allnurses');
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
      
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> gettodaysoutvisits(BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/gettodaysoutpatients";

//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
    
//     try {
//       // if (_cache.isCacheValid(Outvisits)) return;
//       //  final cached = _cache.get<List<Map<String, dynamic>>>(Outvisits);
//       // if (cached != null) {
//       //   gettodaysvisits = cached;
//       //   notifyListeners();
//       //   return;
//       // }
//       print(url);

//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         gettodaysvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//             //  _cache.markCached(Outvisits);
//             // _cache.set(Outvisits, gettodaysvisits);
//             print("today outvisit: ${gettodaysvisits}");
//         notifyListeners();
//       }else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
    
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         gettodaysvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//             // _cache.set(Outvisits, gettodaysvisits);
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         print('No visits found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//       } 
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//       else if (response.statusCode == 404) {
//         print('No visits found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> addinvisit(
//       String patientId,
//       String Chiefcomplaint,
//       String visitingdoctor,
//       String dutydoctor,
//       String supportingstaff,
//       BuildContext context) async {
//     try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//       };

//       if (visitingdoctor.isNotEmpty) {
//         requestBody["visitingDoctor"] = visitingdoctor;
//       }
//       if (dutydoctor.isNotEmpty) {
//         requestBody["dutyDoctor"] = dutydoctor;
//       }
//       if (supportingstaff.isNotEmpty) {
//         requestBody["associatedNurse"] = supportingstaff;
//       }
    
//       print(requestBody);

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addinvisit/$patientId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         addinginvisit = false;
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'In Visit added successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

//         invalidateCache(key: PatientInvisits);
//         invalidateCache();
//         getpatientinvisits(patientId, context);

//         notifyListeners();

//         Navigator.pop(context);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//       };

//       if (visitingdoctor.isNotEmpty) {
//         requestBody["visitingDoctor"] = visitingdoctor;
//       }
//       if (dutydoctor.isNotEmpty) {
//         requestBody["dutyDoctor"] = dutydoctor;
//       }
//       if (supportingstaff.isNotEmpty) {
//         requestBody["associatedNurse"] = supportingstaff;
//       }
    
//       print(requestBody);

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addinvisit/$patientId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         addinginvisit = false;
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'In Visit added successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

//         invalidateCache(key: PatientInvisits);
//         invalidateCache();
//         getpatientinvisits(patientId, context);

//         notifyListeners();

//         Navigator.pop(context);
//       } 
//       else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addinginvisit = false;
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addinginvisit = false;
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addinginvisit = false;
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addinginvisit = false;
//     }
//   }

//   Future<void> getactiveinvisits(BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getallactiveinvisits";

//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
    
//     try {
//       // if (_cache.isCacheValid(Invisits)) return;
//       // final cached = _cache.get<List<Map<String, dynamic>>>(Invisits);
//       // if (cached != null) {
//       //   activeinvisits = cached;
//       //   notifyListeners();
//       //   return;
//       // }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         activeinvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
// // _cache.markCached(Invisits);
//         // _cache.set(Invisits, activeinvisits);

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         activeinvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();
// // _cache.markCached(Invisits);
        
//                 // _cache.set(Invisits, activeinvisits);
// notifyListeners();
//       } else if (response.statusCode == 404) {
//         print('No visits found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         print('No visits found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getpatientdiagnosis(String id, int visitindex, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getindiagnosis/$id/$visitindex";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         invisitId = json.decode(response.body)['invisitId'];
//         print(invisitId);
//         patientdiagnosis =
//             json.decode(response.body)['diagnosis'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         invisitId = json.decode(response.body)['invisitId'];
//         print(invisitId);
//         patientdiagnosis =
//             json.decode(response.body)['diagnosis'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getallpatientdiagnosis(String id, String complaintid, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getalldiagnosis/$id/$complaintid";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientalldiagnosis =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       }else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientalldiagnosis =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getallobservations(String id, String invistid, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getallobservations/$id/$invistid";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientallobservations =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       }else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientallobservations =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> addinpatientdiagnosis(
//     String patientId,
//     String complaintId,
//     int visitIndex,
//     String complaint,
//     String diagnosis,
//     String medicaladvice,
//     String labtest,
//     String doctorremark,
//     String followupdate,
//     List<Map<String, dynamic>> vitals,
//     List<Map<String, dynamic>> medication,
//     List<File> supportingfiles,
//     BuildContext context,
//   ) async {
//           Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//     var url = Uri.parse(
//         '${Constants.baseUrl}/api/v1/hospitaldoctor/addindiagnosis/$patientId/$complaintId');
//         print(url);

//     var request = http.MultipartRequest('POST', url);

//     request.headers['Authorization'] = 'Bearer ${Constants.doctortoken}';

//     // Add form-data fields
//     request.fields['complaint'] = complaint;

//     request.fields['diagnosis_summary'] = diagnosis;

//     if (medicaladvice.isNotEmpty) {
//       request.fields["medical_advice"] = medicaladvice;
//     }

//     if (labtest.isNotEmpty) {
//       request.fields["lab_test"] = labtest;
//     }
//     if (doctorremark.isNotEmpty) {
//       request.fields["doctors_remark"] = doctorremark;
//     }
//     if (followupdate.isNotEmpty) {
//       request.fields["followup_date"] = followupdate;
//     }

//     if (supportingfiles.isNotEmpty) {
//       for (var file in supportingfiles) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'attachments', // this name must match `req.files` in Node.js multer setup
//           file.path,
//         ));
//       }
//     }
//     if (vitals.isNotEmpty && vitals[0]["name"] != "") {
     
//       request.fields['vitals'] = jsonEncode(vitals);
//     } else {
//       request.fields['vitals'] = '[]'; 
//     }
//     if (medication.isNotEmpty && medication[0]["medicine"] != "") {
//       // formData["medication"] =
//       //     jsonEncode(medication); // Convert List to JSON String
//       request.fields['medication'] = jsonEncode(medication);
//     } else {
//       request.fields['medication'] = '[]'; // Send empty list as string
//     }

//     print(request.fields);
//     print("Files being sent:");
//     for (var f in request.files) {
//       print("Field: ${f.field}, filename: ${f.filename}");
//     }
//     // Send as empty list in string form

//     try {
//       // Send the request
//       var streamedResponse = await request.send();

//       // Convert to standard response
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//          isSavingIndiagnosis = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         invalidateCache();
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Diagnosis added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientdiagnosis(patientId, visitIndex, context);
//         Navigator.pop(context);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       // Send the request
//       var streamedResponse = await request.send();

//       // Convert to standard response
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//          isSavingIndiagnosis = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Diagnosis added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientdiagnosis(patientId, visitIndex, context);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//         isSavingIndiagnosis = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//           isSavingIndiagnosis = false;
//           notifyListeners();
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//         isSavingIndiagnosis = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//           isSavingIndiagnosis = false;
//           notifyListeners();
//     }
//   }

// Future<void> dischargeInPatient(
//       String patientId,
//       String complaintId,
//       String dischargesummary,
//       String followupdate,
//       String patientname,
//       int visitingindex,
//       BuildContext context) async {
//     try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "discharge_summary": dischargesummary,
//       };

//       if (followupdate.isNotEmpty) {
//       requestBody["followup_date"] = followupdate;
//     }


//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/dischargepatient/$patientId/$complaintId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         invalidateCache();
//         invalidateCache(key: Invisits);
//         invalidateCache(key: Outvisits);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient Discharged successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        
//         getpatientinvisits(patientId, context);
//         getactiveinvisits(context);
//  filteredactiveinvisits = activeinvisits; 
//         notifyListeners();

//         Navigator.pop(context);

//         await context.router.popAndPush(ViewDiagnosisRoute(id: patientId, name: patientname,dischargeddate: "discharged", visitingIndex:visitingindex ));
        
        
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         try {
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "discharge_summary": dischargesummary,
//       };

//       if (followupdate.isNotEmpty) {
//       requestBody["followup_date"] = followupdate;
//     }


//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/dischargepatient/$patientId/$complaintId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient Discharged successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         invalidateCache();
// reset();
//         getpatientinvisits(patientId, context);
//         getactiveinvisits(context);
//  filteredactiveinvisits = activeinvisits; 

//         notifyListeners();

//         Navigator.pop(context);

//         await context.router.popAndPush(PatientInvisitsRoute(patientId: patientId, name: patientname));
        
        
//       } else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       // print(error);
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print(response.body);
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       // print(error);
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }

//   Future<void> getoutvisitsupportingfiles(String patientId, String complaintId, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getsupportingdocs/$patientId/$complaintId";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
        
//         outvisitsupportingfiles = responseData['data'];
//          print(outvisitsupportingfiles);   
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
        
//         outvisitsupportingfiles = responseData['data'];
//          print(outvisitsupportingfiles);   
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
  

//   Future<void> getinvisitsupportingfiles(String patientId, String complaintId, String diagnosisId, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getsupportingdocsdiagnosis/$patientId/$complaintId/$diagnosisId";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
        
//         invisitsupportingfiles = responseData['data'];
//          print(invisitsupportingfiles);   
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
        
//         invisitsupportingfiles = responseData['data'];
//          print(invisitsupportingfiles);   
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> deletesupportingfile(String patientId, String complaintId, String fileUrl, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/deletefilesfrombunny";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     try {
//       final response = await http.delete(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'patientId': patientId,
//           'complaintId':complaintId,
//           'fileUrl':fileUrl,
//         }),
//       );

//       if (response.statusCode == 200) {
//         isDeleting = false;

//          final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Files deleted Sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getoutvisitsupportingfiles(patientId, complaintId, context);
//         Navigator.of(context).pop();
        
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.delete(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'patientId': patientId,
//           'complaintId':complaintId,
//           'fileUrl':fileUrl,
//         }),
//       );

//       if (response.statusCode == 200) {
//         isDeleting = false;

//          final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Files deleted Sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getoutvisitsupportingfiles(patientId, complaintId, context);
//         Navigator.of(context).pop();
        
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         Navigator.of(context).pop();
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//       else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         Navigator.of(context).pop();
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> deletediagnosissupportingfile(String patientId, String complaintId, String diagnosisId, String fileUrl, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/deletefilesfrombunnydiagnosis";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     try {
//       final response = await http.delete(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'patientId': patientId,
//           'complaintId':complaintId,
//           'diagnosisId' : diagnosisId,
//           'fileUrl':fileUrl,
//         }),
//       );

//       if (response.statusCode == 200) {
//         isDeleting = false;

//          final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Files deleted Sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getinvisitsupportingfiles(patientId, complaintId,diagnosisId, context);
//         Navigator.of(context).pop();
        
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.delete(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'patientId': patientId,
//           'complaintId':complaintId,
//           'diagnosisId' : diagnosisId,
//           'fileUrl':fileUrl,
//         }),
//       );

//       if (response.statusCode == 200) {
//         isDeleting = false;

//          final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Files deleted Sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getinvisitsupportingfiles(patientId, complaintId,diagnosisId, context);
//         Navigator.of(context).pop();
        
//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         Navigator.of(context).pop();
//         isDeleting = true;
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         Navigator.of(context).pop();
//         isDeleting = true;
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }


//   Future<void> getallsharedpatients(BuildContext context) async {
  
//    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getallsharedpatients";

//   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

//       // Get new patients from response
//       List<Map<String, dynamic>> newPatients = json.decode(response.body)['patients'].cast<Map<String, dynamic>>();

//       allsharedpatients = newPatients;


//       // if (page == 1) {
//       //   // First page or new search - replace existing data
//       //   allpatients = newPatients;
//       //   filteredPatients = [...allpatients];
//       // } else {
//       //   // Subsequent pages - append data
//       //   allpatients.addAll(newPatients);
//       //   filteredPatients = [...allpatients];
//       // }
      
//       notifyListeners();
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

//       // Get new patients from response
//       List<Map<String, dynamic>> newPatients = json.decode(response.body)['patients'].cast<Map<String, dynamic>>();

//       allsharedpatients = newPatients;


//       // if (page == 1) {
//       //   // First page or new search - replace existing data
//       //   allpatients = newPatients;
//       //   filteredPatients = [...allpatients];
//       // } else {
//       //   // Subsequent pages - append data
//       //   allpatients.addAll(newPatients);
//       //   filteredPatients = [...allpatients];
//       // }
      
//       notifyListeners();
//     } else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
// }

// Future<bool> requsetaccess(String phone,String dob, BuildContext context) async {
    
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/reqpatienthistory";
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     print(url);
//     print(phone);
//     print(dob);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'

//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',
//            ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'phone': phone,
//           'DOB': dob,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'OTP sent sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         return true;
//         // context.router.popAndPush(OtpVerificationRoute());
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//          Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',
//            ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'phone': phone,
//           'DOB': dob,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'OTP sent sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         return true;
//         // context.router.popAndPush(OtpVerificationRoute());
//       } else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       return false;
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//         return false;
//       }
//        else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       return false;
//     }
//   }

//   Future<bool> requsetdirectaccess(String phone,String dob, BuildContext context) async {
    
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/requestpatienthistory8217309343";
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     print(url);
//     print(phone);
//     print(dob);

//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',
//            ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'phone': phone,
//           'DOB': dob,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient data fetched sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//          getallsharedpatients(context);
//          notifyListeners();
//         return true;
//         // context.router.popAndPush(OtpVerificationRoute());
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',
//            ...headers,
//         },
//         body: jsonEncode(<String, dynamic>{
//           'phone': phone,
//           'DOB': dob,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Patient data fetched sucessfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//          getallsharedpatients(context);
//          notifyListeners();
//         return true;
//         // context.router.popAndPush(OtpVerificationRoute());
//       } else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       return false;
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//         return false;
//       }
//        else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.white),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       return false;
//     }
//   }

//   Future<void> verifyphoneOtp(
//       String phone,String dob, String otp, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/verifypatienthistoryotp";
//     print(dob);
//     print(phone);
//     print(otp);

//           Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//     try {

//         final Map<String, dynamic> requestBody = {
//         'phone': phone,
//           'DOB': dob,
//           'otp': otp,
//       };

// print(requestBody);
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',

//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
        

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getallsharedpatients(context);
         
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {

//         final Map<String, dynamic> requestBody = {
//         'phone': phone,
//           'DOB': dob,
//           'otp': otp,
//       };

// print(requestBody);
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${Constants.doctortoken}',

//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         // Successful POST request, handle the response here
//         final responseData = jsonDecode(response.body);
//         print(responseData);
        

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getallsharedpatients(context);
         
//         notifyListeners();
//       } else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(responseData['msg'],
//                 style: TextStyle(color: Colors.grey[50])));
       
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
        
//       }
//       //  else {
//       //   // result = '';

//       //   // If the server returns an error response, throw an exception
//       //   Constants.otpverification = false;
//       //   throw Exception(response.body);
//       // }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
      
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(responseData['msg'],
//                 style: TextStyle(color: Colors.grey[50])));
       
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
        
//       }
//       //  else {
//       //   // result = '';

//       //   // If the server returns an error response, throw an exception
//       //   Constants.otpverification = false;
//       //   throw Exception(response.body);
//       // }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
      
//     }
//   }

//   Future<void> getsharedpatientinoutvisits(String patientid, BuildContext context ) async {
  
//    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getsharedpatientinoutvisits/$patientid";

//   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

      
//        sharedpatientinvisits = json.decode(response.body)['invisits'].cast<Map<String, dynamic>>();
//        print(sharedpatientinvisits);

// sharedpatientoutvisits = json.decode(response.body)['outvisits'].cast<Map<String, dynamic>>();
//       print(sharedpatientoutvisits);
      
//       notifyListeners();
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
// Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);

      
//        sharedpatientinvisits = json.decode(response.body)['invisits'].cast<Map<String, dynamic>>();
//        print(sharedpatientinvisits);

// sharedpatientoutvisits = json.decode(response.body)['outvisits'].cast<Map<String, dynamic>>();
//       print(sharedpatientoutvisits);
      
//       notifyListeners();
//     } else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }

//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {
//       print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
// }

// Future<void> getimportpatientalldiagnosis(String id, String invisitId, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getallshareddiagnosis/$id/$invisitId";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         importpatientalldiagnosis =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         // invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         importpatientalldiagnosis =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//         // print(responseData);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<String?> getdoctorinremark(String patientId, String invisitId, String diagnosisId, BuildContext context) async {
  
//    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getdoctorinremarks/$patientId/$invisitId/$diagnosisId";

//    Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);
//        return responseData["doctors_remark"];
      
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);
//        return responseData["doctors_remark"];
      
//     } else {

//       print('Error: ${response.statusCode} - ${response.body}');
//       return "";
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {

//       print('Error: ${response.statusCode} - ${response.body}');
//       return "";
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
// }


// Future<String?> getdoctorremark(String patientId, String complaintId, BuildContext context ) async {
  
//    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getdoctorremarks/$patientId/$complaintId";

//   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);
//        return responseData["doctors_remark"];
      
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);
//        return responseData["doctors_remark"];
      
//     } else {

//       print('Error: ${response.statusCode} - ${response.body}');
//       return "";
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {

//       print('Error: ${response.statusCode} - ${response.body}');
//       return "";
//     }
//   } catch (e) {
//     print("Exception in getPatientsByPageWithSearch: $e");
//   }
// }

// Future<void> getpatienthistoryairesponse(String patientid, BuildContext context) async {
//  Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//   String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getcomplaintsai/$patientid";

//   final headers = await DeviceHeaders.getDeviceHeaders();



//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//         ...headers,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

      
//       if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
//         patienthistorydata = data['ai_response'].toString();
//       } else {
//         patienthistorydata = "Unexpected response format.";
//       }

//       notifyListeners(); // Notify if using a provider
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//        Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//         ...headers,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

      
//       if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
//         patienthistorydata = data['ai_response'].toString();
//       } else {
//         patienthistorydata = "Unexpected response format.";
//       }

//       notifyListeners(); // Notify if using a provider
//     } else {
//       print('Error: ${response.statusCode}, ${response.body}');
//     }
//   } catch (e) {
//     print("Exception: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {
//       print('Error: ${response.statusCode}, ${response.body}');
//     }
//   } catch (e) {
//     print("Exception: $e");
//   }
// }


// Future<void> getinpatienthistoryairesponse(String patientid, String id, BuildContext context) async {
//  Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//   String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getcomplaintsinai/$patientid/$id";

//   final headers = await DeviceHeaders.getDeviceHeaders();


//   print("url: $url");

//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//         ...headers,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print(data);

      
//       if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
//         inpatienthistorydata = data['ai_response'].toString();
//       } else {
//         inpatienthistorydata = "Unexpected response format.";
//       }

//       notifyListeners(); // Notify if using a provider
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//       Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.doctortoken}',
//         ...headers,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print(data);

      
//       if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
//         inpatienthistorydata = data['ai_response'].toString();
//       } else {
//         inpatienthistorydata = "Unexpected response format.";
//       }

//       notifyListeners(); // Notify if using a provider
//     } else {
//       print('Error: ${response.statusCode}, ${response.body}');
//     }
//   } catch (e) {
//     print("Exception: $e");
//   }
//     }
//     else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//      else {
//       print('Error: ${response.statusCode}, ${response.body}');
//     }
//   } catch (e) {
//     print("Exception: $e");
//   }
// }

// bool iseditingvisit = false;


// Future<void> editvisit(String patientid, String complaintid, String Chiefcomplaint, String height, String weight,
//   String bp, String temperature, String heartrate,
//   List<Map<String, dynamic>> vitals,
//    BuildContext context,) async {
//     try {
//       // Constants.token = await secureStorage.readSecureData('token') ?? '';
//  Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//       final headers = await DeviceHeaders.getDeviceHeaders();

      

//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//         // "height": height,
//         // "weight": weight,
//         // "bp": bp,
//         // "temperature": temperature,
//         // "heart_rate": heartrate,
//       };

//       if (height.isNotEmpty) {
//         requestBody["height"] = height;
//       }
//       if (weight.isNotEmpty) {
//         requestBody["weight"] = weight;
//       }
//       if (bp.isNotEmpty) {
//         requestBody["bp"] = bp;
//       }
//       if (temperature.isNotEmpty) {
//         requestBody["temperature"] = temperature;
//       }
//       if (heartrate.isNotEmpty) {
//         requestBody["heart_rate"] = heartrate;
//       }
//           if (vitals.isNotEmpty) requestBody["vitals"] = vitals;   // ← NEW


// print(requestBody);


//       String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/editoutvisit/$patientid/$complaintid";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         iseditingvisit = false;
//         final responseData = jsonDecode(response.body);
// invalidateCache(key: PatientOutvisits);
// invalidateCache();
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Patient details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         getpatient(patientid, context);
//           await getpatientoutvisits(patientid, context);

//         // getallpatients();
        

//         notifyListeners();

//         Navigator.pop(context);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         try {
//       // Constants.token = await secureStorage.readSecureData('token') ?? '';
//  Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';

//       final headers = await DeviceHeaders.getDeviceHeaders();

      

//       final Map<String, dynamic> requestBody = {
//         "chief_complaint": Chiefcomplaint,
//         // "height": height,
//         // "weight": weight,
//         // "bp": bp,
//         // "temperature": temperature,
//         // "heart_rate": heartrate,
//       };

//       if (height.isNotEmpty) {
//         requestBody["height"] = height;
//       }
//       if (weight.isNotEmpty) {
//         requestBody["weight"] = weight;
//       }
//       if (bp.isNotEmpty) {
//         requestBody["bp"] = bp;
//       }
//       if (temperature.isNotEmpty) {
//         requestBody["temperature"] = temperature;
//       }
//       if (heartrate.isNotEmpty) {
//         requestBody["heart_rate"] = heartrate;
//       }
//           if (vitals.isNotEmpty) requestBody["vitals"] = vitals;   // ← NEW


// print(requestBody);


//       String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/editoutvisit/$patientid/$complaintid";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctortoken}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         iseditingvisit = false;
//         final responseData = jsonDecode(response.body);

//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Patient details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         getpatient(patientid, context);
//           await getpatientoutvisits(patientid, context);

//         // getallpatients();
        

//         notifyListeners();

//         Navigator.pop(context);
//       } else {
//         iseditingvisit = false;
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       iseditingvisit = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         iseditingvisit = false;
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       iseditingvisit = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }


// Future<void> refreshtoken(BuildContext context) async {
//     try {
//       print("Refresh token is called here");
//       Constants.doctorrefreshtoken = await secureStorage.readSecureData('doctorrefreshtoken') ?? '';

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/refreshtokendoctoradminmobile'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctorrefreshtoken}',
//           'Content-Type': 'application/json',
//           // ...headers,
//         },
//       );

//       if (response.statusCode == 200) {
//        print(response.body);
//         final responseData = jsonDecode(response.body);
// await secureStorage.writeSecureData('doctortoken', responseData['token']);
//         await secureStorage.writeSecureData('doctorrefreshtoken', responseData['refreshToken']);
//         await secureStorage.readSecureData('doctortoken').then((value) {
//           Constants.doctortoken = value;
//         });

//   await secureStorage.readSecureData('doctorrefreshtoken').then((value) {
//           Constants.doctorrefreshtoken = value;
//         });
//         print("Constants.doctortoken ${Constants.doctortoken}");
//         print("Constants.doctorrefreshtoken ${Constants.doctorrefreshtoken}");


//         notifyListeners();
//       } 
//       else if (response.statusCode == 401) {
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('doctortoken');
//         await secureStorage.deleteSecureData('doctorrefreshtoken');
      
//         Constants.doctortoken = '';
//         Constants.doctorrefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print(
//             "Refresh failed with status: ${response.statusCode} — ${response.body}");
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//     }
//   }
  

//   Future<void> logout() async {
//     try {
//       Constants.doctorrefreshtoken = await secureStorage.readSecureData('doctorrefreshtoken') ?? '';


//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/logoutphone'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.doctorrefreshtoken}',
//           'Content-Type': 'application/json',
//         },
//       );
//       print(response);
//       invalidateCache();
//       _cache.invalidateAll();
      
//        } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
     
//     }
//   }

//    void invalidateCache({String? key}) {
//     if (key != null) {
//       _cache.invalidate(key);
//     } else {
//       _cache.invalidateAll(); // Clears everything app-wide now
//     }
//   }

//   void reset() {
//    patientinvisits = [];
//    activeinvisits = [];
//      _cache.invalidateAll();
//     notifyListeners();
//   }


// void notify() {
//     notifyListeners();
//   }

// }


import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/cacheManager.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/deviceHeader.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;

class Doctorprovider extends ChangeNotifier {
  List<Map<String, dynamic>> doctordetailedprofile = [];
  List<Map<String, dynamic>> patients = [];
  List<Map<String, dynamic>> filteredPatients = [];
  List<Map<String, dynamic>> allpatients = [];
  List<Map<String, dynamic>> patientdetails = [];
  List<Map<String, dynamic>> patientinvisits = [];
  List<Map<String, dynamic>> patientoutvisits = [];
  List<Map<String, dynamic>> alldoctors = [];
  List<Map<String, dynamic>> allnurses = [];
  List<Map<String, dynamic>> gettodaysvisits = [];
  List<Map<String, dynamic>> filteredvisits = [];
  List<Map<String, dynamic>> activeinvisits = [];
  List<Map<String, dynamic>> filteredactiveinvisits = [];
  List<Map<String, dynamic>> patientdiagnosis = [];
  List<Map<String, dynamic>> patientalldiagnosis = [];
  List<Map<String, dynamic>> importpatientalldiagnosis = [];
  List<Map<String, dynamic>> patientallobservations = [];
  List<dynamic> outvisitsupportingfiles = [];
  List<dynamic> invisitsupportingfiles = [];
  List<Map<String, dynamic>> allsharedpatients = [];
  List<Map<String, dynamic>> filteredallsharedpatients = [];
  List<Map<String, dynamic>> sharedpatientinvisits = [];
  List<Map<String, dynamic>> sharedpatientoutvisits = [];

  final CacheManager _cache = CacheManager();

  final String kPatients = 'patients';
  final String kProfile = 'profile';
  final String Invisits = 'invisits';
  final String Outvisits = 'outvisits';
  final String PatientInvisits = 'patientinvisits';
  final String PatientOutvisits = 'patientoutvisits';

  String invisitId = '';
  bool isDeleting = false;
  bool isSavingOutdisagnosis = false;
  bool isSavingIndiagnosis = false;
  bool addinginvisit = false;
  bool addingoutvisit = false;
  bool addingpatient = false;
  bool editingpatient = false;
  bool iseditingvisit = false;

  String patienthistorydata = "";
  String inpatienthistorydata = "";

  final SecureStorage secureStorage = SecureStorage();

  // ===========================================================================
  // CORE AUTH INFRASTRUCTURE
  // ===========================================================================

  /// Guarantees only ONE refresh-token HTTP call is ever in flight at a time.
  /// Every caller that hits a 401/403 while a refresh is already running just
  /// awaits the same Future instead of firing its own refresh request. This is
  /// what prevents the "random logout" race condition: with refresh-token
  /// rotation on the backend, two parallel refresh calls using the same old
  /// refresh token would otherwise cause the second one to fail and log the
  /// user out even though the first one just succeeded.
  Future<bool>? _refreshFuture;

  Future<bool> refreshtoken(BuildContext context) {
    _refreshFuture ??= _doRefresh(context).whenComplete(() {
      _refreshFuture = null;
    });
    return _refreshFuture!;
  }

  Future<bool> _doRefresh(BuildContext context) async {
    try {
      print("Refresh token is called here");
      final currentRefreshToken =
          await secureStorage.readSecureData('doctorrefreshtoken') ?? '';

      if (currentRefreshToken.isEmpty) {
        await _forceLogout(context);
        return false;
      }

      final response = await http.post(
        Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitaldoctor/refreshtokendoctoradminmobile'),
        headers: <String, String>{
          'Authorization': 'Bearer $currentRefreshToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {}

        if (body == null || body['success'] == false) {
          print("Refresh returned 200 but success:false — $body");
          await _forceLogout(context);
          return false;
        }

        await secureStorage.writeSecureData('doctortoken', body['token']);
        await secureStorage.writeSecureData(
            'doctorrefreshtoken', body['refreshToken']);

        Constants.doctortoken = body['token'];
        Constants.doctorrefreshtoken = body['refreshToken'];

        print("Constants.doctortoken ${Constants.doctortoken}");
        print("Constants.doctorrefreshtoken ${Constants.doctorrefreshtoken}");

        notifyListeners();
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await _forceLogout(context);
        return false;
      } else {
        print(
            "Refresh failed with status: ${response.statusCode} — ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in refreshtoken: $e");
      return false;
    }
  }

  Future<void> _forceLogout(BuildContext context) async {
    await secureStorage.deleteSecureData('doctortoken');
    await secureStorage.deleteSecureData('doctorrefreshtoken');

    Constants.doctortoken = '';
    Constants.doctorrefreshtoken = '';

    await logout();
    if (context.mounted) context.router.popAndPush(SplashRoute());
    notifyListeners();
  }

  /// Generic wrapper for any authenticated request (GET/POST/PUT/DELETE or
  /// multipart). [requestFn] receives the current doctor token and must
  /// build + send the request, returning the http.Response. Because
  /// [requestFn] is re-invoked on retry, it must build a *fresh* request
  /// each time it's called (important for MultipartRequest, which can only
  /// be sent once).
  ///
  /// Handles:
  ///  - real 401 / 403
  ///  - the "200 OK but {success:false}" pattern some endpoints use
  ///  - a single refresh-and-retry, using the single-flight refresh lock
  ///  - forced logout if the retry also fails
  ///
  /// Returns null if the request ultimately failed (network exception,
  /// logged out, or refresh failed) — callers should treat null as
  /// "nothing to do, already handled".
  Future<http.Response?> _sendAuthenticated(
    BuildContext context,
    Future<http.Response> Function(String token) requestFn, {
    bool isRetry = false,
  }) async {
    final token = await secureStorage.readSecureData('doctortoken') ?? '';
    Constants.doctortoken = token;

    http.Response response;
    try {
      response = await requestFn(token);
    } catch (e) {
      print("Network exception: $e");
      return null;
    }

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}

    final bool isUnauthorized = response.statusCode == 401 ||
        response.statusCode == 403 ||
        (response.statusCode == 200 &&
            body is Map &&
            body?['success'] == false);

    if (isUnauthorized) {
      if (isRetry) {
        // Already retried once after a refresh and still unauthorized —
        // the session really is dead.
        await _forceLogout(context);
        return null;
      }

      final refreshed = await refreshtoken(context);
      if (refreshed) {
        return _sendAuthenticated(context, requestFn, isRetry: true);
      }
      // refreshtoken() already force-logged-out internally on real failure.
      return null;
    }

    return response;
  }

  // ===========================================================================
  // PROFILE
  // ===========================================================================

  Future<void> getdoctordetailedprofile(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getmydetailprofile";

    final cached = _cache.get<List<Map<String, dynamic>>>(kProfile);
    if (cached != null) {
      doctordetailedprofile = cached;
      notifyListeners();
      return;
    }

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['myprofile'];

      if (data is List) {
        doctordetailedprofile = List<Map<String, dynamic>>.from(data);
      } else if (data is Map) {
        doctordetailedprofile = [Map<String, dynamic>.from(data)];
        print('doctor details : $doctordetailedprofile');
      }
      _cache.set(kProfile, doctordetailedprofile);
      notifyListeners();
    } else {
      print('${response.body}');
    }
  }

  // ===========================================================================
  // PATIENTS
  // ===========================================================================

  Future<void> getpatientbydoctor(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data == null) {
        print('No patients found');
        return;
      }
      patients = (data as List).cast<Map<String, dynamic>>();
      print(patients);
      notifyListeners();
    } else if (response.statusCode == 404) {
      print('No patients found');
    } else {
      print(response.body);
    }
  }

  Future<void> getPatientsByPageWithSearch(
      int page, String searchQuery, BuildContext context) async {
    final String url = searchQuery.isNotEmpty
        ? "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor?page=$page&search=${Uri.encodeComponent(searchQuery)}"
        : "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor?page=$page";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      final data = responseData['data'];
      if (data == null) {
        print('No data in response');
        return;
      }

      final List<Map<String, dynamic>> newPatients =
          (data as List).cast<Map<String, dynamic>>();
      print(newPatients);

      if (page == 1) {
        allpatients = newPatients;
        filteredPatients = [...allpatients];
      } else {
        allpatients.addAll(newPatients);
        filteredPatients = [...allpatients];
      }

      notifyListeners();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> getPatientsByPage(int page, BuildContext context) async {
    await getPatientsByPageWithSearch(page, '', context);
  }

  Future<void> addpatient(String name, String phone, String gender,
      String email, String dob, BuildContext context) async {
    final Map<String, dynamic> requestBody = {
      "name": name,
      "gender": gender,
      "phone": phone,
      "DOB": dob,
    };
    if (email.isNotEmpty) requestBody["email"] = email;

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/addpatient'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) {
      addingpatient = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      addingpatient = false;
      print(responseData);
      invalidateCache(key: kPatients);
      _cache.invalidateAll();
      notifyListeners();

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Patient Registered successfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      getPatientsByPage(1, context);
      Navigator.pop(context);
    } else {
      print(response.body);
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      addingpatient = false;
      notifyListeners();
    }
  }

  Future<void> getpatient(String id, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbyid/$id";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      if (data is List) {
        patientdetails = List<Map<String, dynamic>>.from(data);
      } else if (data is Map) {
        patientdetails = [Map<String, dynamic>.from(data)];
      }
      notifyListeners();
    } else {
      print('${response.body}');
    }
  }

  Future<void> editpatient(String id, String name, String dob, String gender,
      String email, String phone, BuildContext context) async {
    print("name: $name gender: $gender DOB: $dob email: $email phone: $phone");

    final Map<String, dynamic> requestBody = {
      "name": name,
      "gender": gender,
      "DOB": dob,
      "email": email,
      "phone": phone,
    };

    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/editpatient/$id";

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) {
      editingpatient = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      editingpatient = false;
      invalidateCache(key: kPatients);
      await getpatient(id, context);

      print(responseData);
      final msg = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            "Patient details updated Successfully",
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(msg);
      getPatientsByPage(1, context);
      Navigator.pop(context);
      notifyListeners();
    } else {
      final responseData = jsonDecode(response.body);
      editingpatient = false;
      final msg = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData['msg'],
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(msg);
      notifyListeners();
    }
  }

  // ===========================================================================
  // VISITS
  // ===========================================================================

  Future<void> getpatientinvisits(String id, BuildContext context) async {
    final String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getinvisit/$id";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      patientinvisits = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // no visits
    } else {
      print(response.body);
    }
  }

  Future<void> getpatientoutvisits(String id, BuildContext context) async {
    final String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getoutvisit/$id";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      patientoutvisits = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // no visits
    } else {
      print(response.body);
    }
  }

  Future<void> addoutvisit(
      String patientId,
      String Chiefcomplaint,
      String height,
      String weight,
      String bp,
      String temperature,
      String heartrate,
      List<Map<String, dynamic>> vitals,
      BuildContext context) async {
    final Map<String, dynamic> requestBody = {
      "chief_complaint": Chiefcomplaint,
    };
    if (height.isNotEmpty) requestBody["height"] = height;
    if (weight.isNotEmpty) requestBody["weight"] = weight;
    if (bp.isNotEmpty) requestBody["bp"] = bp;
    if (heartrate.isNotEmpty) requestBody["heart_rate"] = heartrate;
    if (temperature.isNotEmpty) requestBody["temperature"] = temperature;
    if (vitals.isNotEmpty) requestBody["vitals"] = vitals;
    print(requestBody);

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse(
              '${Constants.baseUrl}/api/v1/hospitaldoctor/addoutvisit/$patientId'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) {
      addingoutvisit = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      addingoutvisit = false;
      final responseData = jsonDecode(response.body);
      print(responseData);

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Out Visit added successfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      invalidateCache(key: PatientOutvisits);

      getpatientoutvisits(patientId, context);
      notifyListeners();
      Navigator.pop(context);
    } else {
      print(response.body);
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      addingoutvisit = false;
      notifyListeners();
    }
  }

  Future<void> adddiagnosis(
    String patientId,
    String complaintId,
    String diagnosis,
    String medicaladvice,
    String labtest,
    String doctorremark,
    String followupdate,
    List<Map<String, dynamic>> medication,
    List<File> supportingfiles,
    BuildContext context,
  ) async {
    final response = await _sendAuthenticated(
      context,
      (token) async {
        final url = Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitaldoctor/addoutdiagnosis/$patientId/$complaintId');
        final request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'Bearer $token';

        request.fields['diagnosis_summary'] = diagnosis;
        if (medicaladvice.isNotEmpty) {
          request.fields["medical_advice"] = medicaladvice;
        }
        if (labtest.isNotEmpty) request.fields["lab_test"] = labtest;
        if (doctorremark.isNotEmpty) {
          request.fields["doctors_remark"] = doctorremark;
        }
        if (followupdate.isNotEmpty) {
          request.fields["followup_date"] = followupdate;
        }
        if (supportingfiles.isNotEmpty) {
          for (var file in supportingfiles) {
            request.files.add(
                await http.MultipartFile.fromPath('attachments', file.path));
          }
        }
        if (medication.isNotEmpty && medication[0]["medicine"] != "") {
          request.fields['medication'] = jsonEncode(medication);
        } else {
          request.fields['medication'] = '[]';
        }

        print(request.fields);
        for (var f in request.files) {
          print("Field: ${f.field}, filename: ${f.filename}");
        }

        final streamedResponse = await request.send();
        return http.Response.fromStream(streamedResponse);
      },
    );

    if (response == null) {
      isSavingOutdisagnosis = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      isSavingOutdisagnosis = false;
      print("Success: ${response.body}");
      final responseData = jsonDecode(response.body);
      print(responseData);
      invalidateCache();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: Text('Diagnosis added successfully',
            style: TextStyle(color: Colors.white)),
      ));
      getpatientoutvisits(patientId, context);
      gettodaysoutvisits(context);
      notifyListeners();
      Navigator.pop(context);
    } else {
      print("Failed: ${response.statusCode}, ${response.body}");
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(responseData["msg"],
            style: TextStyle(fontWeight: FontWeight.bold)),
      ));
      isSavingOutdisagnosis = false;
      notifyListeners();
    }
  }

  Future<void> getdoctorsnurses(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getalldoctorsnurses";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final doctorsData = responseData['doctors'];
      final nursesData = responseData['nurses'];
      alldoctors = doctorsData == null
          ? []
          : (doctorsData as List).cast<Map<String, dynamic>>();
      allnurses = nursesData == null
          ? []
          : (nursesData as List).cast<Map<String, dynamic>>();
      print('alldoctors $alldoctors');
      print('allnurses $allnurses');
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none found
    } else {
      print(response.body);
    }
  }

  Future<void> gettodaysoutvisits(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/gettodaysoutpatients";
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      gettodaysvisits = (data as List).cast<Map<String, dynamic>>();
      print("today outvisit: $gettodaysvisits");
      notifyListeners();
    } else if (response.statusCode == 404) {
      print('No visits found');
    } else {
      print(response.body);
    }
  }

  Future<void> addinvisit(
      String patientId,
      String Chiefcomplaint,
      String visitingdoctor,
      String dutydoctor,
      String supportingstaff,
      BuildContext context) async {
    final Map<String, dynamic> requestBody = {
      "chief_complaint": Chiefcomplaint,
    };
    if (visitingdoctor.isNotEmpty) {
      requestBody["visitingDoctor"] = visitingdoctor;
    }
    if (dutydoctor.isNotEmpty) requestBody["dutyDoctor"] = dutydoctor;
    if (supportingstaff.isNotEmpty) {
      requestBody["associatedNurse"] = supportingstaff;
    }
    print(requestBody);

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse(
              '${Constants.baseUrl}/api/v1/hospitaldoctor/addinvisit/$patientId'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) {
      addinginvisit = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 201) {
      addinginvisit = false;
      final responseData = jsonDecode(response.body);
      print(responseData);

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'In Visit added successfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      invalidateCache(key: PatientInvisits);
      invalidateCache();
      getpatientinvisits(patientId, context);
      notifyListeners();
      Navigator.pop(context);
    } else {
      print(response.body);
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      addinginvisit = false;
      notifyListeners();
    }
  }

  Future<void> getactiveinvisits(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getallactiveinvisits";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      activeinvisits = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      print('No visits found');
    } else {
      print(response.body);
    }
  }

  Future<void> getpatientdiagnosis(
      String id, int visitindex, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getindiagnosis/$id/$visitindex";
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      invisitId = responseData['invisitId'];
      print(invisitId);
      final data = responseData['diagnosis'];
      if (data == null) return;
      patientdiagnosis = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // no diagnosis
    } else {
      print(response.body);
    }
  }

  Future<void> getallpatientdiagnosis(
      String id, String complaintid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getalldiagnosis/$id/$complaintid";
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      patientalldiagnosis = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none
    } else {
      print(response.body);
    }
  }

  Future<void> getallobservations(
      String id, String invistid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getallobservations/$id/$invistid";
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      patientallobservations = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none
    } else {
      print(response.body);
    }
  }

  Future<void> addinpatientdiagnosis(
    String patientId,
    String complaintId,
    int visitIndex,
    String complaint,
    String diagnosis,
    String medicaladvice,
    String labtest,
    String doctorremark,
    String followupdate,
    List<Map<String, dynamic>> vitals,
    List<Map<String, dynamic>> medication,
    List<File> supportingfiles,
    BuildContext context,
  ) async {
    final url = Uri.parse(
        '${Constants.baseUrl}/api/v1/hospitaldoctor/addindiagnosis/$patientId/$complaintId');
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'Bearer $token';

        request.fields['complaint'] = complaint;
        request.fields['diagnosis_summary'] = diagnosis;

        if (medicaladvice.isNotEmpty) {
          request.fields["medical_advice"] = medicaladvice;
        }
        if (labtest.isNotEmpty) request.fields["lab_test"] = labtest;
        if (doctorremark.isNotEmpty) {
          request.fields["doctors_remark"] = doctorremark;
        }
        if (followupdate.isNotEmpty) {
          request.fields["followup_date"] = followupdate;
        }
        if (supportingfiles.isNotEmpty) {
          for (var file in supportingfiles) {
            request.files.add(
                await http.MultipartFile.fromPath('attachments', file.path));
          }
        }
        if (vitals.isNotEmpty && vitals[0]["name"] != "") {
          request.fields['vitals'] = jsonEncode(vitals);
        } else {
          request.fields['vitals'] = '[]';
        }
        if (medication.isNotEmpty && medication[0]["medicine"] != "") {
          request.fields['medication'] = jsonEncode(medication);
        } else {
          request.fields['medication'] = '[]';
        }

        print(request.fields);
        for (var f in request.files) {
          print("Field: ${f.field}, filename: ${f.filename}");
        }

        final streamedResponse = await request.send();
        return http.Response.fromStream(streamedResponse);
      },
    );

    if (response == null) {
      isSavingIndiagnosis = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      isSavingIndiagnosis = false;
      print("Success: ${response.body}");
      final responseData = jsonDecode(response.body);
      print(responseData);
      invalidateCache();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: Text('Diagnosis added successfully',
            style: TextStyle(color: Colors.white)),
      ));
      getpatientdiagnosis(patientId, visitIndex, context);
      Navigator.pop(context);
      notifyListeners();
    } else {
      print("Failed: ${response.statusCode}, ${response.body}");
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(responseData["msg"],
            style: TextStyle(fontWeight: FontWeight.bold)),
      ));
      isSavingIndiagnosis = false;
      notifyListeners();
    }
  }

  Future<void> dischargeInPatient(
      String patientId,
      String complaintId,
      String dischargesummary,
      String followupdate,
      String patientname,
      int visitingindex,
      BuildContext context) async {
    final Map<String, dynamic> requestBody = {
      "discharge_summary": dischargesummary,
    };
    if (followupdate.isNotEmpty) requestBody["followup_date"] = followupdate;

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse(
              '${Constants.baseUrl}/api/v1/hospitaldoctor/dischargepatient/$patientId/$complaintId'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) return;

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      invalidateCache();
      invalidateCache(key: Invisits);
      invalidateCache(key: Outvisits);
      notifyListeners();

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Patient Discharged successfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      getpatientinvisits(patientId, context);
      getactiveinvisits(context);
      filteredactiveinvisits = activeinvisits;
      notifyListeners();

      Navigator.pop(context);

      await context.router.popAndPush(ViewDiagnosisRoute(
        id: patientId,
        name: patientname,
        dischargeddate: "discharged",
        visitingIndex: visitingindex,
      ));
    } else {
      print(response.body);
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  // ===========================================================================
  // SUPPORTING FILES
  // ===========================================================================

  Future<void> getoutvisitsupportingfiles(
      String patientId, String complaintId, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getsupportingdocs/$patientId/$complaintId";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      outvisitsupportingfiles = responseData['data'] ?? [];
      print(outvisitsupportingfiles);
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none
    } else {
      print(response.body);
    }
  }

  Future<void> getinvisitsupportingfiles(String patientId, String complaintId,
      String diagnosisId, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getsupportingdocsdiagnosis/$patientId/$complaintId/$diagnosisId";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      invisitsupportingfiles = responseData['data'] ?? [];
      print(invisitsupportingfiles);
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none
    } else {
      print(response.body);
    }
  }

  Future<void> deletesupportingfile(String patientId, String complaintId,
      String fileUrl, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/deletefilesfrombunny";

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
          body: jsonEncode(<String, dynamic>{
            'patientId': patientId,
            'complaintId': complaintId,
            'fileUrl': fileUrl,
          }),
        );
      },
    );

    if (response == null) {
      isDeleting = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      isDeleting = false;
      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Files deleted Sucessfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      getoutvisitsupportingfiles(patientId, complaintId, context);
      Navigator.of(context).pop();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData['msg'],
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
    }
  }

  Future<void> deletediagnosissupportingfile(String patientId,
      String complaintId, String diagnosisId, String fileUrl, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/deletefilesfrombunnydiagnosis";

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
          body: jsonEncode(<String, dynamic>{
            'patientId': patientId,
            'complaintId': complaintId,
            'diagnosisId': diagnosisId,
            'fileUrl': fileUrl,
          }),
        );
      },
    );

    if (response == null) {
      isDeleting = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      isDeleting = false;
      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Files deleted Sucessfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      getinvisitsupportingfiles(patientId, complaintId, diagnosisId, context);
      Navigator.of(context).pop();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData['msg'],
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
      isDeleting = true;
      notifyListeners();
    }
  }

  // ===========================================================================
  // SHARED PATIENTS
  // ===========================================================================

  Future<void> getallsharedpatients(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getallsharedpatients";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['patients'];
      if (data == null) return;
      allsharedpatients = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool> requsetaccess(
      String phone, String dob, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/reqpatienthistory";
    print(url);
    print(phone);
    print(dob);

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
          body: jsonEncode(<String, dynamic>{
            'phone': phone,
            'DOB': dob,
          }),
        );
      },
    );

    if (response == null) return false;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'OTP sent sucessfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      return true;
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
  }

  Future<bool> requsetdirectaccess(
      String phone, String dob, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/requestpatienthistory8217309343";
    print(url);
    print(phone);
    print(dob);

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
          body: jsonEncode(<String, dynamic>{
            'phone': phone,
            'DOB': dob,
          }),
        );
      },
    );

    if (response == null) return false;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Patient data fetched sucessfully',
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      getallsharedpatients(context);
      notifyListeners();
      return true;
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
  }

  Future<void> verifyphoneOtp(
      String phone, String dob, String otp, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/verifypatienthistoryotp";
    print(dob);
    print(phone);
    print(otp);

    final Map<String, dynamic> requestBody = {
      'phone': phone,
      'DOB': dob,
      'otp': otp,
    };
    print(requestBody);

    final response = await _sendAuthenticated(
      context,
      (token) => http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      final sucessSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            responseData['msg'],
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      getallsharedpatients(context);
      notifyListeners();
    } else {
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content:
              Text(responseData['msg'], style: TextStyle(color: Colors.grey[50])));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> getsharedpatientinoutvisits(
      String patientid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getsharedpatientinoutvisits/$patientid";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      final inData = responseData['invisits'];
      final outData = responseData['outvisits'];
      sharedpatientinvisits =
          inData == null ? [] : (inData as List).cast<Map<String, dynamic>>();
      sharedpatientoutvisits = outData == null
          ? []
          : (outData as List).cast<Map<String, dynamic>>();
      print(sharedpatientinvisits);
      print(sharedpatientoutvisits);

      notifyListeners();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> getimportpatientalldiagnosis(
      String id, String invisitId, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getallshareddiagnosis/$id/$invisitId";
    print(url);

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final data = responseData['data'];
      if (data == null) return;
      importpatientalldiagnosis = (data as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      // none
    } else {
      print(response.body);
    }
  }

  Future<String?> getdoctorinremark(String patientId, String invisitId,
      String diagnosisId, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getdoctorinremarks/$patientId/$invisitId/$diagnosisId";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return "";

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      return responseData["doctors_remark"];
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return "";
    }
  }

  Future<String?> getdoctorremark(
      String patientId, String complaintId, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getdoctorremarks/$patientId/$complaintId";

    final response = await _sendAuthenticated(
      context,
      (token) => http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response == null) return "";

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      return responseData["doctors_remark"];
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return "";
    }
  }

  // ===========================================================================
  // AI HISTORY
  // ===========================================================================

  Future<void> getpatienthistoryairesponse(
      String patientid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getcomplaintsai/$patientid";

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
        );
      },
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
        patienthistorydata = data['ai_response'].toString();
      } else {
        patienthistorydata = "Unexpected response format.";
      }
      notifyListeners();
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> getinpatienthistoryairesponse(
      String patientid, String id, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/getcomplaintsinai/$patientid/$id";
    print("url: $url");

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            ...headers,
          },
        );
      },
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data is Map<String, dynamic> && data.containsKey('ai_response')) {
        inpatienthistorydata = data['ai_response'].toString();
      } else {
        inpatienthistorydata = "Unexpected response format.";
      }
      notifyListeners();
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  // ===========================================================================
  // EDIT VISIT
  // ===========================================================================

  Future<void> editvisit(
    String patientid,
    String complaintid,
    String Chiefcomplaint,
    String height,
    String weight,
    String bp,
    String temperature,
    String heartrate,
    List<Map<String, dynamic>> vitals,
    BuildContext context,
  ) async {
    final Map<String, dynamic> requestBody = {
      "chief_complaint": Chiefcomplaint,
    };
    if (height.isNotEmpty) requestBody["height"] = height;
    if (weight.isNotEmpty) requestBody["weight"] = weight;
    if (bp.isNotEmpty) requestBody["bp"] = bp;
    if (temperature.isNotEmpty) requestBody["temperature"] = temperature;
    if (heartrate.isNotEmpty) requestBody["heart_rate"] = heartrate;
    if (vitals.isNotEmpty) requestBody["vitals"] = vitals;
    print(requestBody);

    final String url =
        "${Constants.baseUrl}/api/v1/hospitaldoctor/editoutvisit/$patientid/$complaintid";

    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        return http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            ...headers,
          },
          body: jsonEncode(requestBody),
        );
      },
    );

    if (response == null) {
      iseditingvisit = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      iseditingvisit = false;
      final responseData = jsonDecode(response.body);
      invalidateCache(key: PatientOutvisits);
      invalidateCache();
      print(responseData);

      final msg = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            "Patient details updated Successfully",
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(msg);

      getpatient(patientid, context);
      await getpatientoutvisits(patientid, context);

      notifyListeners();
      Navigator.pop(context);
    } else {
      iseditingvisit = false;
      final responseData = jsonDecode(response.body);
      final msg = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData['msg'],
            style: TextStyle(color: Colors.grey[50]),
          ));
      ScaffoldMessenger.of(context).showSnackBar(msg);
      notifyListeners();
    }
  }

  // ===========================================================================
  // LOGOUT / CACHE / MISC
  // ===========================================================================

  Future<void> logout() async {
    try {
      final refreshToken =
          await secureStorage.readSecureData('doctorrefreshtoken') ?? '';

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/logoutphone'),
        headers: <String, String>{
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      );
      print(response);
      invalidateCache();
      _cache.invalidateAll();
    } catch (e) {
      print(e);
    }
  }

  void invalidateCache({String? key}) {
    if (key != null) {
      _cache.invalidate(key);
    } else {
      _cache.invalidateAll();
    }
  }

  void reset() {
    patientinvisits = [];
    activeinvisits = [];
    _cache.invalidateAll();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}