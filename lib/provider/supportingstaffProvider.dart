import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

     static const String kPatients = 'patients';
  static const String kProfile  = 'profile';

    String invisitId = '';
       bool isDeleting = false;

       bool addingobservation = false;
       bool addingoutvisit = false;  
       bool updatinginvisit = false;


  final SecureStorage secureStorage = SecureStorage();


  Future<void> getadmindetailedprofile() async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getmydetailprofile";

    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    
    try {
 if (_cache.isCacheValid(kProfile)) return;

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['myprofile'];

        if (data is List) {
          supportingstaffdetailedprofile = List<Map<String, dynamic>>.from(data);
          
 _cache.markCached(kProfile);
          notifyListeners();
        } else if (data is Map) {
          supportingstaffdetailedprofile = [Map<String, dynamic>.from(data)];
          print('Supporting staff details : $supportingstaffdetailedprofile');
          // print(doctordetailedprofile);
        }
        notifyListeners();
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['myprofile'];

        if (data is List) {
          supportingstaffdetailedprofile = List<Map<String, dynamic>>.from(data);
          

          notifyListeners();
        } else if (data is Map) {
          supportingstaffdetailedprofile = [Map<String, dynamic>.from(data)];
          print('Supporting staff details : $supportingstaffdetailedprofile');
          // print(doctordetailedprofile);
        }
        notifyListeners();
      } else {
        print('${response.body}');
      }
    } catch (e) {
      print(e);
    }
      }
       else {
        print('${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }



Future<void> getpatientbydoctor() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getpatientbydoctor";

    Constants.token = await secureStorage.readSecureData('doctortoken') ?? '';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        patients =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401)
{
  await refreshtoken();
  Constants.token = await secureStorage.readSecureData('doctortoken') ?? '';
  try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        patients =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if (response.statusCode == 404) {
        print('No patients found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
}       else if (response.statusCode == 404) {
        print('No patients found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }


Future<void> getPatientsByPageWithSearch(int page, String searchQuery) async {
  final String url = searchQuery.isNotEmpty 
      ? "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page&search=${Uri.encodeComponent(searchQuery)}"
      : "${Constants.baseUrl}/api/v1/hospitalnurse/getassociatedpatients?page=$page";

  Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
  print(Constants.nursetoken);

  try {

 if (page == 1 && searchQuery.isEmpty && _cache.isCacheValid(kPatients)) {
      return; // ← Serve from cache, skip API
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.nursetoken}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      // Get new patients from response
      List<Map<String, dynamic>> newPatients = json.decode(response.body)['data'].cast<Map<String, dynamic>>();

      if (page == 1) {
        // First page or new search - replace existing data
        allpatients = newPatients;
        filteredPatients = [...allpatients];
      } else {
        // Subsequent pages - append data
        allpatients.addAll(newPatients);
        filteredPatients = [...allpatients];
      }

       if (page == 1 && searchQuery.isEmpty) {
        _cache.markCached(kPatients); // ← Mark as cached after success
      }
      notifyListeners();
    } else if(response.statusCode == 401){
      await refreshtoken();
      Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
      try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.nursetoken}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      // Get new patients from response
      List<Map<String, dynamic>> newPatients = json.decode(response.body)['data'].cast<Map<String, dynamic>>();

      if (page == 1) {
        // First page or new search - replace existing data
        allpatients = newPatients;
        filteredPatients = [...allpatients];
      } else {
        // Subsequent pages - append data
        allpatients.addAll(newPatients);
        filteredPatients = [...allpatients];
      }
      
      notifyListeners();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print("Exception in getPatientsByPageWithSearch: $e");
  }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print("Exception in getPatientsByPageWithSearch: $e");
  }
}

Future<void> getPatientsByPage(int page) async {
  await getPatientsByPageWithSearch(page, '');
}

  Future<void> addpatient(String name, String phone, String gender,
      String email, String dob, BuildContext context) async {
    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "phone": phone,
        "DOB": dob,
      };

      if (email.isNotEmpty) {
        requestBody["email"] = email;
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addpatient'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

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
        getPatientsByPage(1);
        Navigator.pop(context);
      } else if(response.statusCode == 401){
        await refreshtoken();
        try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "phone": phone,
        "DOB": dob,
      };

      if (email.isNotEmpty) {
        requestBody["email"] = email;
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addpatient'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

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
        getPatientsByPage(1);
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


Future<void> getpatientinvisits(String id) async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getinvisitsbyptients/$id";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        patientinvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        patientinvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
  }

Future<void> getallpatientdiagnosis(String id, String invisitid) async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getalldiagnosis/$id/$invisitid";
    print(url);
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientalldiagnosis =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientalldiagnosis =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getallobservations(String id, String invistid) async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getallobservations/$id/$invistid";
    print(url);
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientallobservations =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientallobservations =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getpatientobservations(String id, int visitindex) async {
    String url = "${Constants.baseUrl}/api/v1/hospitalnurse/getobservation/$id/$visitindex";
    print(url);
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("responseData: $responseData" );
        invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientobservations =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.nursetoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("responseData: $responseData" );
        invisitId = json.decode(response.body)['invisitId'];
        // print(invisitId);
        patientobservations =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
      }
    } catch (e) {
      print(e);
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
          Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
          final headers = await DeviceHeaders.getDeviceHeaders();


    var url = Uri.parse(
        '${Constants.baseUrl}/api/v1/hospitalnurse/addobservation/$patientId/$complaintId');
        print(url);

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${Constants.nursetoken}';
    request.headers.addAll(headers);

    // Add form-data fields
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
    // Send as empty list in string form

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert to standard response
      var response = await http.Response.fromStream(streamedResponse);

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
getpatientobservations(patientId, visitIndex);
        Navigator.pop(context);
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';
        try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert to standard response
      var response = await http.Response.fromStream(streamedResponse);

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
getpatientobservations(patientId, visitIndex);
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
    } catch (e) {
      print("Error: $e");
      addingobservation = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
          addingobservation = false;
          notifyListeners();
    }
      }
       else {
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
    } catch (e) {
      print("Error: $e");
      addingobservation = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
          addingobservation = false;
          notifyListeners();
    }
  }

  Future<void> refreshtoken() async {
    try {
      Constants.nurserefreshtoken = await secureStorage.readSecureData('nurserefreshtoken') ?? '';


      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitalnurse/refreshtokennursemobile'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.nurserefreshtoken}',
          'Content-Type': 'application/json',
          // ...headers,
        },
      );

      if (response.statusCode == 200) {
       print(response.body);
        final responseData = jsonDecode(response.body);
await secureStorage.writeSecureData('nursetoken', responseData['token']);
        await secureStorage.writeSecureData('nurserefreshtoken', responseData['refreshToken']);
        await secureStorage.readSecureData('nursetoken').then((value) {
          Constants.nursetoken= value;
        });

  await secureStorage.readSecureData('nurserefreshtoken').then((value) {
          Constants.nurserefreshtoken = value;
        });
        print("Constants.nursetoken ${Constants.nursetoken}");
        print("Constants.nurserefreshtoken ${Constants.nurserefreshtoken}");


        notifyListeners();
      } else {
        print(response.body);
        final responseData = jsonDecode(response.body);
       
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
    }
  }


Future<void> logout() async {
    try {
      Constants.nurserefreshtoken = await secureStorage.readSecureData('nurserefreshtoken') ?? '';

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitalnurse/logoutphone'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.nurserefreshtoken}',
          'Content-Type': 'application/json',
        },
      );
      invalidateCache();
      print(response);

    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
     
    }
  }

   void invalidateCache({String? key}) {
    if (key != null) {
      _cache.invalidate(key);
    } else {
      _cache.invalidateAll(); // Clears everything
    }
  }
  

void notify() {
    notifyListeners();
  }

}

