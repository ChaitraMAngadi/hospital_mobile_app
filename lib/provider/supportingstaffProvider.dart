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


// class Supportingstaffprovider extends ChangeNotifier {
//     List<Map<String, dynamic>> supportingstaffdetailedprofile = [];
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
//     List<Map<String, dynamic>> patientobservations = [];
//     List<Map<String, dynamic>> patientalldiagnosis = [];
//     List<Map<String, dynamic>> patientallobservations = [];
//     List<dynamic> outvisitsupportingfiles = [];
//     List<dynamic> invisitsupportingfiles = [];
//     List<Map<String, dynamic>> complaintdetails = [];

//     final CacheManager _cache = CacheManager(cacheDuration: Duration(minutes: 10));

//      final String kPatients = 'patients';
//   final String kProfile  = 'profile';

//     String invisitId = '';
//        bool isDeleting = false;

//        bool addingobservation = false;
//        bool addingoutvisit = false;  
//        bool updatinginvisit = false;


//   final SecureStorage secureStorage = SecureStorage();


//   Future<void> getadmindetailedprofile(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getmydetailprofile";

//     Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    
//     try {
// //  if (_cache.isCacheValid(kProfile)) return;
// final cached = _cache.get<List<Map<String, dynamic>>>(kProfile);
//       if (cached != null) {
//         supportingstaffdetailedprofile = cached;
//         notifyListeners();
//         return;
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['myprofile'];

//         if (data is List) {
//           supportingstaffdetailedprofile = List<Map<String, dynamic>>.from(data);
          
//           notifyListeners();
//         } else if (data is Map) {
//           supportingstaffdetailedprofile = [Map<String, dynamic>.from(data)];
//           print('Supporting staff details : $supportingstaffdetailedprofile');
//           // print(doctordetailedprofile);
//         }

//         //  _cache.markCached(kProfile);
//         _cache.set(kProfile, supportingstaffdetailedprofile);

//         notifyListeners();
//       }else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['myprofile'];

//         if (data is List) {
//           supportingstaffdetailedprofile = List<Map<String, dynamic>>.from(data);
          

//           notifyListeners();
//         } else if (data is Map) {
//           supportingstaffdetailedprofile = [Map<String, dynamic>.from(data)];
//           print('Supporting staff details : $supportingstaffdetailedprofile');
//           // print(doctordetailedprofile);
//         }
//                 _cache.set(kProfile, supportingstaffdetailedprofile);

//         notifyListeners();
//       } else {
//         print('${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//       }
//       else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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

//         notifyListeners();
//       } else if(response.statusCode == 401)
// {
//   await refreshtoken(context);
//   Constants.token = await secureStorage.readSecureData('doctortoken') ?? '';
//   try {
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

//         notifyListeners();
//       } else if (response.statusCode == 404) {
//         print('No patients found');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }
//  else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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
//       ? "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page&search=${Uri.encodeComponent(searchQuery)}"
//       : "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page";

//   Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//   print(Constants.nursetoken);

//   try {

// //  if (page == 1 && searchQuery.isEmpty && _cache.isCacheValid(kPatients)) {
// //       return; // ← Serve from cache, skip API
// //     }

//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.nursetoken}',
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

//       //  if (page == 1 && searchQuery.isEmpty) {
//       //   _cache.markCached(kPatients); // ← Mark as cached after success
//       // }
//       notifyListeners();
//     } else if(response.statusCode == 401){
//       await refreshtoken(context);
//       Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//       try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${Constants.nursetoken}',
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
//      else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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
//       Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

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
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addpatient'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.admintoken}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
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
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         try {
//       Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

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
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addpatient'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.admintoken}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
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
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//       }
//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }


// Future<void> getpatientinvisits(String id, BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getinvisitsbyptients/$id";
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientinvisits =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         patientinvisits =
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
//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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

// Future<void> getallpatientdiagnosis(String id, String invisitid, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getalldiagnosis/$id/$invisitid";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
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
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
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
//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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

//   Future<void> getallobservations(String id, String invistid, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getallobservations/$id/$invistid";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
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
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
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
//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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

//   Future<void> getpatientobservations(String id, int visitindex, BuildContext context ) async {
//     String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getobservation/$id/$visitindex";
//     print(url);
//     // '${Constants.baseUrl}/app/log-in/phone-otp'
//     Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("responseData: $responseData" );
//         invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientobservations =
//             json.decode(response.body)['data'].cast<Map<String, dynamic>>();

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.nursetoken}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("responseData: $responseData" );
//         invisitId = json.decode(response.body)['invisitId'];
//         // print(invisitId);
//         patientobservations =
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
//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
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

//   Future<void> addobservation(
//     String patientId,
//     String complaintId,
//     int visitIndex,
//     dynamic summary,
//     List<Map<String, dynamic>> vitals,
//     bool ismedicationontime,
//     BuildContext context,
//   ) async {
//           Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//           final headers = await DeviceHeaders.getDeviceHeaders();


//     var url = Uri.parse(
//         '${Constants.baseUrl}/api/v1/hospitalnurse/addobservation/$patientId/$complaintId');
//         print(url);

//     var request = http.MultipartRequest('POST', url);

//     request.headers['Authorization'] = 'Bearer ${Constants.nursetoken}';
//     request.headers.addAll(headers);

//     // Add form-data fields
//     request.fields['summary'] = summary;

// request.fields['ismedicineOnTime'] = ismedicationontime.toString();
  
//     if (vitals.isNotEmpty && vitals[0]["name"] != "") {
     
//       request.fields['vitals'] = jsonEncode(vitals);
//     } else {
//       request.fields['vitals'] = '[]'; 
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
//          addingobservation = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Observation added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientobservations(patientId, visitIndex, context);
//         Navigator.pop(context);
//       }else if(response.statusCode == 401){
//         await refreshtoken(context);
//         Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
//         try {
//       // Send the request
//       var streamedResponse = await request.send();

//       // Convert to standard response
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//          addingobservation = false;
//         print("Success: ${response.body}");
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Observation added successfully',
//               style: TextStyle(color: Colors.white)),
//         ));
// getpatientobservations(patientId, visitIndex, context);
//         Navigator.pop(context);
//       } else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         addingobservation = false;
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//         notifyListeners();
        
//       }
//     } catch (e) {
//       print("Error: $e");
//       addingobservation = false;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//           addingobservation = false;
//           notifyListeners();
//     }
//       }

//        else if(response.statusCode == 403 ){
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
      
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
//         logout();
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//         notifyListeners();
//       }
//        else {
//         print("Failed: ${response.statusCode}, ${response.body}");
//         addingobservation = false;
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(responseData["msg"],
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ));
//         notifyListeners();
        
//       }
//     } catch (e) {
//       print("Error: $e");
//       addingobservation = false;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//           addingobservation = false;
//           notifyListeners();
//     }
//   }

//   Future<void> refreshtoken(BuildContext context) async {
//     try {
//       Constants.nurserefreshtoken = await secureStorage.readSecureData('nurserefreshtoken') ?? '';


//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitalnurse/refreshtokennursemobile'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.nurserefreshtoken}',
//           'Content-Type': 'application/json',
//           // ...headers,
//         },
//       );

//       if (response.statusCode == 200) {
//        print(response.body);
//         final responseData = jsonDecode(response.body);
// await secureStorage.writeSecureData('nursetoken', responseData['token']);
//         await secureStorage.writeSecureData('nurserefreshtoken', responseData['refreshToken']);
//         await secureStorage.readSecureData('nursetoken').then((value) {
//           Constants.nursetoken= value;
//         });

//   await secureStorage.readSecureData('nurserefreshtoken').then((value) {
//           Constants.nurserefreshtoken = value;
//         });
//         print("Constants.nursetoken ${Constants.nursetoken}");
//         print("Constants.nurserefreshtoken ${Constants.nurserefreshtoken}");


//         notifyListeners();
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         await secureStorage.deleteSecureData('nursetoken');
//         await secureStorage.deleteSecureData('nurserefreshtoken');
//         Constants.nursetoken = '';
//         Constants.nurserefreshtoken = '';
//         if (context.mounted) context.router.popAndPush(SplashRoute());
//       } else {
//         print(
//             "Refresh failed with status: ${response.statusCode} — ${response.body}");
//       }
//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//     }
//   }


// Future<void> logout() async {
//     try {
//       Constants.nurserefreshtoken = await secureStorage.readSecureData('nurserefreshtoken') ?? '';

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/hospitalnurse/logoutphone'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.nurserefreshtoken}',
//           'Content-Type': 'application/json',
//         },
//       );
//       invalidateCache();
//       _cache.invalidateAll();
//       notifyListeners();
//       print(response);

//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
     
//     }
//   }

//    void invalidateCache({String? key}) {
//     if (key != null) {
//       _cache.invalidate(key);
      
//          } else {
//       _cache.invalidateAll(); // Clears everything
//     }
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


class Supportingstaffprovider extends ChangeNotifier {
    List<Map<String, dynamic>> supportingstaffdetailedprofile = [];
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
    List<Map<String, dynamic>> patientobservations = [];
    List<Map<String, dynamic>> patientalldiagnosis = [];
    List<Map<String, dynamic>> patientallobservations = [];
    List<dynamic> outvisitsupportingfiles = [];
    List<dynamic> invisitsupportingfiles = [];
    List<Map<String, dynamic>> complaintdetails = [];

    final CacheManager _cache = CacheManager(cacheDuration: Duration(minutes: 10));

     final String kPatients = 'patients';
  final String kProfile  = 'profile';

    String invisitId = '';
       bool isDeleting = false;

       bool addingobservation = false;
       bool addingoutvisit = false;  
       bool updatinginvisit = false;


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
      final currentRefreshToken =
          await secureStorage.readSecureData('nurserefreshtoken') ?? '';

      if (currentRefreshToken.isEmpty) {
        await _forceLogout(context);
        return false;
      }

      final response = await http.post(
        Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitalnurse/refreshtokennursemobile'),
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

        await secureStorage.writeSecureData('nursetoken', body['token']);
        await secureStorage.writeSecureData(
            'nurserefreshtoken', body['refreshToken']);

        Constants.nursetoken = body['token'];
        Constants.nurserefreshtoken = body['refreshToken'];

        print("Constants.nursetoken ${Constants.nursetoken}");
        print("Constants.nurserefreshtoken ${Constants.nurserefreshtoken}");

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
    await secureStorage.deleteSecureData('nursetoken');
    await secureStorage.deleteSecureData('nurserefreshtoken');

    Constants.nursetoken = '';
    Constants.nurserefreshtoken = '';

    await logout();
    if (context.mounted) context.router.popAndPush(SplashRoute());
    notifyListeners();
  }

  /// Generic wrapper for any authenticated request (GET/POST/PUT/DELETE or
  /// multipart). [requestFn] receives the current token for [tokenKey] and
  /// must build + send the request, returning the http.Response. Because
  /// [requestFn] is re-invoked on retry, it must build a *fresh* request
  /// each time it's called (important for MultipartRequest, which can only
  /// be sent once).
  ///
  /// [tokenKey] defaults to 'nursetoken' since that's what most endpoints in
  /// this provider use, but a couple of methods historically call
  /// doctor/admin endpoints with their own tokens — pass the matching key
  /// for those so the read/retry logic still targets the right token.
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
    String tokenKey = 'nursetoken',
    bool isRetry = false,
  }) async {
    final token = await secureStorage.readSecureData(tokenKey) ?? '';
    if (tokenKey == 'nursetoken') {
      Constants.nursetoken = token;
    } else if (tokenKey == 'doctortoken') {
      Constants.token = token;
    } else if (tokenKey == 'admintoken') {
      Constants.admintoken = token;
    }

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
        return _sendAuthenticated(context, requestFn,
            tokenKey: tokenKey, isRetry: true);
      }
      // refreshtoken() already force-logged-out internally on real failure.
      return null;
    }

    return response;
  }

  // ===========================================================================
  // PROFILE
  // ===========================================================================

  Future<void> getadmindetailedprofile(BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitalnurse/getmydetailprofile";

    final cached = _cache.get<List<Map<String, dynamic>>>(kProfile);
    if (cached != null) {
      supportingstaffdetailedprofile = cached;
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
        supportingstaffdetailedprofile = List<Map<String, dynamic>>.from(data);
      } else if (data is Map) {
        supportingstaffdetailedprofile = [Map<String, dynamic>.from(data)];
        print('Supporting staff details : $supportingstaffdetailedprofile');
      }
      _cache.set(kProfile, supportingstaffdetailedprofile);
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
      tokenKey: 'doctortoken',
    );
    if (response == null) return;

    if (response.statusCode == 200) {
      patients =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
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
        ? "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page&search=${Uri.encodeComponent(searchQuery)}"
        : "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page";

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

      List<Map<String, dynamic>> newPatients =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();

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
    if (email.isNotEmpty) {
      requestBody["email"] = email;
    }

    try {
      final response = await _sendAuthenticated(
        context,
        (token) => http.post(
          Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addpatient'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        ),
        tokenKey: 'admintoken',
      );

      if (response == null) return;

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(responseData);
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
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  // ===========================================================================
  // VISITS / DIAGNOSIS / OBSERVATIONS
  // ===========================================================================

  Future<void> getpatientinvisits(String id, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitalnurse/getinvisitsbyptients/$id";

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
      patientinvisits =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      // print(responseData);
    } else {
      print(response.body);
    }
  }

  Future<void> getallpatientdiagnosis(
      String id, String invisitid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitalnurse/getalldiagnosis/$id/$invisitid";
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
      patientalldiagnosis =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      // print(responseData);
    } else {
      print(response.body);
    }
  }

  Future<void> getallobservations(
      String id, String invistid, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitalnurse/getallobservations/$id/$invistid";
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
      patientallobservations =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      // print(responseData);
    } else {
      print(response.body);
    }
  }

  Future<void> getpatientobservations(
      String id, int visitindex, BuildContext context) async {
    final String url =
        "${Constants.baseUrl}/api/v1/hospitalnurse/getobservation/$id/$visitindex";
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
      print("responseData: $responseData");
      invisitId = json.decode(response.body)['invisitId'];
      patientobservations =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      notifyListeners();
    } else if (response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      // print(responseData);
    } else {
      print(response.body);
    }
  }

  Future<void> addobservation(
    String patientId,
    String complaintId,
    int visitIndex,
    dynamic summary,
    List<Map<String, dynamic>> vitals,
    bool ismedicationontime,
    BuildContext context,
  ) async {
    final response = await _sendAuthenticated(
      context,
      (token) async {
        final headers = await DeviceHeaders.getDeviceHeaders();
        final url = Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitalnurse/addobservation/$patientId/$complaintId');
        print(url);

        final request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'Bearer $token';
        request.headers.addAll(headers);

        request.fields['summary'] = summary;
        request.fields['ismedicineOnTime'] = ismedicationontime.toString();

        if (vitals.isNotEmpty && vitals[0]["name"] != "") {
          request.fields['vitals'] = jsonEncode(vitals);
        } else {
          request.fields['vitals'] = '[]';
        }

        print(request.fields);
        print("Files being sent:");
        for (var f in request.files) {
          print("Field: ${f.field}, filename: ${f.filename}");
        }

        final streamedResponse = await request.send();
        return http.Response.fromStream(streamedResponse);
      },
    );

    if (response == null) {
      addingobservation = false;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      addingobservation = false;
      print("Success: ${response.body}");
      final responseData = jsonDecode(response.body);
      print(responseData);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: Text('Observation added successfully',
            style: TextStyle(color: Colors.white)),
      ));
      getpatientobservations(patientId, visitIndex, context);
      Navigator.pop(context);
    } else {
      print("Failed: ${response.statusCode}, ${response.body}");
      addingobservation = false;
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(responseData["msg"],
            style: TextStyle(fontWeight: FontWeight.bold)),
      ));
      notifyListeners();
    }
  }

  // ===========================================================================
  // LOGOUT / CACHE / MISC
  // ===========================================================================

  Future<void> logout() async {
    try {
      final refreshToken =
          await secureStorage.readSecureData('nurserefreshtoken') ?? '';

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitalnurse/logoutphone'),
        headers: <String, String>{
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      );
      invalidateCache();
      _cache.invalidateAll();
      notifyListeners();
      print(response);
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
    }
  }

  void invalidateCache({String? key}) {
    if (key != null) {
      _cache.invalidate(key);
    } else {
      _cache.invalidateAll();
    }
  }

  void notify() {
    notifyListeners();
  }
}
