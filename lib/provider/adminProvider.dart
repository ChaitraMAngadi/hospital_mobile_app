import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/service/cacheManager.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/deviceHeader.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SlotModel {
  final String startTime;
  final String endTime;
  final String? patientname;
  final String? patientMobile;

  bool get isBooked => patientname != null;

  SlotModel({
    required this.startTime,
    required this.endTime,
    this.patientname,
    this.patientMobile,
  });


  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      startTime: json["startTime"],
      endTime: json["endTime"],
      patientname: json["patientname"],
      patientMobile: json["patientMobile"]?.toString(),
    );
  }
}


 String formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return '';
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

class Adminprovider extends ChangeNotifier {
    List<Map<String, dynamic>> admindetailedprofile = [];
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
    List<Map<String, dynamic>> patientallobservations = [];
    List<dynamic> outvisitsupportingfiles = [];
    List<dynamic> invisitsupportingfiles = [];
    List<Map<String, dynamic>> complaintdetails = [];

      List<Map<String, dynamic>> alldoctorsdetails = [];
      List<Map<String, dynamic>> todaysappointments = [];
  List<Map<String, dynamic>> filteredtodaysappointments = [];


   final CacheManager _cache = CacheManager(cacheDuration: Duration(minutes: 10));

     static const String kPatients = 'patients';
  static const String kProfile  = 'profile';



    String invisitId = '';
       bool isDeleting = false;

       bool addinginvisit = false;
       bool addingoutvisit = false;  
       bool updatinginvisit = false;
       bool addingpatient = false;
       bool editingpatient = false;


  final SecureStorage secureStorage = SecureStorage();


  Future<void> getadmindetailedprofile() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getmydetailprofile";

    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
    try {
      if (_cache.isCacheValid(kProfile)) return;


      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['myprofile'];

        if (data is List) {
          admindetailedprofile = List<Map<String, dynamic>>.from(data);
          
 _cache.markCached(kProfile);

          notifyListeners();
        } else if (data is Map) {
          admindetailedprofile = [Map<String, dynamic>.from(data)];
          print('doctor details : $admindetailedprofile');
          // print(doctordetailedprofile);
        }
        notifyListeners();
      } else if(response.statusCode == 401){
      await  refreshtoken();
Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['myprofile'];

        if (data is List) {
          admindetailedprofile = List<Map<String, dynamic>>.from(data);
          

          notifyListeners();
        } else if (data is Map) {
          admindetailedprofile = [Map<String, dynamic>.from(data)];
          print('doctor details : $admindetailedprofile');
          // print(doctordetailedprofile);
        }
        notifyListeners();
      } 
       else {
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
      } else if(response.statusCode == 401){
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
      } 
      else if (response.statusCode == 404) {
        print('No patients found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

      }
      
      else if (response.statusCode == 404) {
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
      ? "${Constants.baseUrl}/api/v1/hospitaladmin/getallpatients?page=$page&search=${Uri.encodeComponent(searchQuery)}"
      : "${Constants.baseUrl}/api/v1/hospitaladmin/getallpatients?page=$page";

  Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

  try {

    if (page == 1 && searchQuery.isEmpty && _cache.isCacheValid(kPatients)) {
      return; // ← Serve from cache, skip API
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.admintoken}',
      },
    );

    print("response.statusCode:${response.statusCode}");

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
    } 
    else if(response.statusCode == 401) {
      print("response check");

    await  refreshtoken();
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.admintoken}',
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
    }
    
     else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print("Exception in getPatientsByPageWithSearch: $e");
  }


    }
    
     else {
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
      final headers = await DeviceHeaders.getDeviceHeaders();


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
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingpatient = false;
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

    await  refreshtoken();

    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


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
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingpatient = false;
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
      } 
       else {
        print(response.body);
        addingpatient = false;
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
      addingpatient = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }


      }
       else {
        print(response.body);
        addingpatient = false;
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
      addingpatient = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  Future<void> getpatient(String id) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getpatientbyid/$id";
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];

        if (data is List) {
          patientdetails = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        } else if (data is Map) {
          patientdetails = [Map<String, dynamic>.from(data)];
          // print(patientdetails);
          notifyListeners();
        }
        notifyListeners();
        // print(patientdetails);
      } else if(response.statusCode == 401){
        await refreshtoken();

        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';

        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];

        if (data is List) {
          patientdetails = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        } else if (data is Map) {
          patientdetails = [Map<String, dynamic>.from(data)];
          // print(patientdetails);
          notifyListeners();
        }
        notifyListeners();
        // print(patientdetails);
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

  Future<void> editpatient(String id, String name, String dob, String gender,
      String email, String phone, BuildContext context) async {
    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      print(
          "name: $name gender: $gender DOB: $dob email: $email phone: $phone");

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "DOB": dob,
        "phone": phone,
        "email": email,
      };

      String url = "${Constants.baseUrl}/api/v1/hospitaladmin/editpatient/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        editingpatient = false;
        await getpatient(id);
        
        notifyListeners();
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "Patient details updated Successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        getPatientsByPage(1);
        // getallpatients();
        Navigator.pop(context);

        notifyListeners();
      }
      else if(response.statusCode == 401){

        await refreshtoken();

        try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      print(
          "name: $name gender: $gender DOB: $dob email: $email phone: $phone");

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "DOB": dob,
        "phone": phone,
        "email": email,
      };

      String url = "${Constants.baseUrl}/api/v1/hospitaladmin/editpatient/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        editingpatient = false;
        await getpatient(id);
        
        notifyListeners();
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "Patient details updated Successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        getPatientsByPage(1);
        // getallpatients();
        Navigator.pop(context);

        notifyListeners();
      }else {
        final responseData = jsonDecode(response.body);
       editingpatient = false;
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (e) {
      editingpatient = false;
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
      }
      
       else {
        final responseData = jsonDecode(response.body);
       editingpatient = false;
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (e) {
      editingpatient = false;
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }


Future<void> getpatientinvisits(String id) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getinvisitsbypatientid/$id";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
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
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        patientinvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } 
      else if (response.statusCode == 404) {
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

  Future<void> getpatientoutvisits(String id) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getoutvisitsbypatientid/$id";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        patientoutvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        patientoutvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      } 
      else if (response.statusCode == 404) {
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


Future<void> addoutvisit(
      String patientId,
      String cheifcomplaint,
      String height,
      String weight,
      String bp,
      String temperature,
      String heartrate,
      String associatedDoctor,
      BuildContext context) async {
    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "chief_complaint": cheifcomplaint,
        "associatedDoctor": associatedDoctor
      };

      if (height.isNotEmpty) {
        requestBody["height"] = height;
      }
      if (weight.isNotEmpty) {
        requestBody["weight"] = weight;
      }
      if (bp.isNotEmpty) {
        requestBody["bp"] = bp;
      }
      if (heartrate.isNotEmpty) {
        requestBody["heart_rate"] = heartrate;
      }
      if (temperature.isNotEmpty) {
        requestBody["temperature"] = temperature;
      }
      print(requestBody);

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addoutvisit/$patientId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addingoutvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Out Visit added successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientoutvisits(patientId);

        notifyListeners();

        Navigator.pop(context);
      } else if(response.statusCode == 401){
        await refreshtoken();

        try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "chief_complaint": cheifcomplaint,
        "associatedDoctor": associatedDoctor
      };

      if (height.isNotEmpty) {
        requestBody["height"] = height;
      }
      if (weight.isNotEmpty) {
        requestBody["weight"] = weight;
      }
      if (bp.isNotEmpty) {
        requestBody["bp"] = bp;
      }
      if (heartrate.isNotEmpty) {
        requestBody["heart_rate"] = heartrate;
      }
      if (temperature.isNotEmpty) {
        requestBody["temperature"] = temperature;
      }
      print(requestBody);

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addoutvisit/$patientId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addingoutvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Out Visit added successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientoutvisits(patientId);

        notifyListeners();

        Navigator.pop(context);
      } 
       else {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
        addingoutvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      Navigator.pop(context);
      addingoutvisit = false;
    }
      }
       else {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
        addingoutvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      Navigator.pop(context);
      addingoutvisit = false;
    }
  }


Future<void> getinvisitbyid(String patientId, String complaintId) async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getinvisitbyid/$patientId/$complaintId";
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        if (data is List) {
          complaintdetails = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        } else if (data is Map) {
          complaintdetails = [Map<String, dynamic>.from(data)];
          print(complaintdetails);
          notifyListeners();
        }
        notifyListeners();
        // print(patientdetails);
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        if (data is List) {
          complaintdetails = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        } else if (data is Map) {
          complaintdetails = [Map<String, dynamic>.from(data)];
          print(complaintdetails);
          notifyListeners();
        }
        notifyListeners();
        // print(patientdetails);
      } 
       else {
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


Future<void> getdoctorsnurses() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getalldoctorsnurses";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        alldoctors =
            json.decode(response.body)['doctors'].cast<Map<String, dynamic>>();
            allnurses = json.decode(response.body)['nurses'].cast<Map<String, dynamic>>();
            print('alldoctors $alldoctors');
            print('allnurses $allnurses');
        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        alldoctors =
            json.decode(response.body)['doctors'].cast<Map<String, dynamic>>();
            allnurses = json.decode(response.body)['nurses'].cast<Map<String, dynamic>>();
            print('alldoctors $alldoctors');
            print('allnurses $allnurses');
        notifyListeners();
      } 
      else if (response.statusCode == 404) {
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



  Future<void> addinvisit(
      String patientId,
      String cheifcomplaint,
      String consultingdoctor,
      String visitingdoctor,
      String dutydoctor,
      String supportingstaff,
      BuildContext context) async {
    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "chief_complaint": cheifcomplaint,
        "consultingDoctor": consultingdoctor,
      };

      if (visitingdoctor.isNotEmpty) {
        requestBody["visitingDoctor"] = visitingdoctor;
      }
      if (dutydoctor.isNotEmpty) {
        requestBody["dutyDoctor"] = dutydoctor;
      }
      if (supportingstaff.isNotEmpty) {
        requestBody["associatedNurse"] = supportingstaff;
      }
    
      print(requestBody);

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addinvisit/$patientId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addinginvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'In Visit added successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientinvisits(patientId);

        notifyListeners();

        Navigator.pop(context);
      }else if(response.statusCode == 401){
        await refreshtoken();
        try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "chief_complaint": cheifcomplaint,
        "consultingDoctor": consultingdoctor,
      };

      if (visitingdoctor.isNotEmpty) {
        requestBody["visitingDoctor"] = visitingdoctor;
      }
      if (dutydoctor.isNotEmpty) {
        requestBody["dutyDoctor"] = dutydoctor;
      }
      if (supportingstaff.isNotEmpty) {
        requestBody["associatedNurse"] = supportingstaff;
      }
    
      print(requestBody);

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/addinvisit/$patientId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addinginvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'In Visit added successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientinvisits(patientId);

        notifyListeners();

        Navigator.pop(context);
      }
       else {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
        addinginvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      Navigator.pop(context);
      addinginvisit = false;
    }
      }
      
       else {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
        addinginvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      Navigator.pop(context);
      addinginvisit = false;
    }
  }


  Future<void> editinvisit(
      String patientId,
      String complaintId,
      String consultingdoctor,
      String visitingdoctor,
      String dutydoctor,
      String supportingstaff,
      BuildContext context) async {
    try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "consultingDoctor": consultingdoctor,
      };

      if (visitingdoctor.isNotEmpty) {
        requestBody["visitingDoctor"] = visitingdoctor;
      }
      if (dutydoctor.isNotEmpty) {
        requestBody["dutyDoctor"] = dutydoctor;
      }
      if (supportingstaff.isNotEmpty) {
        requestBody["associatedNurse"] = supportingstaff;
      }
    
      print(requestBody);

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/editinvisitbyid/$patientId/$complaintId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        updatinginvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'In-visit updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientinvisits(patientId);
        getinvisitbyid(patientId,complaintId);
        
        getactiveinvisits();

        notifyListeners();

        Navigator.pop(context);
      } else if(response.statusCode == 401){
        await refreshtoken();
        try {
      Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "consultingDoctor": consultingdoctor,
      };

      if (visitingdoctor.isNotEmpty) {
        requestBody["visitingDoctor"] = visitingdoctor;
      }
      if (dutydoctor.isNotEmpty) {
        requestBody["dutyDoctor"] = dutydoctor;
      }
      if (supportingstaff.isNotEmpty) {
        requestBody["associatedNurse"] = supportingstaff;
      }
    
      print(requestBody);

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/editinvisitbyid/$patientId/$complaintId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        updatinginvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'In-visit updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

        getpatientinvisits(patientId);
        getinvisitbyid(patientId,complaintId);
        
        getactiveinvisits();

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
       
        Navigator.pop(context);
         updatinginvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      
      Navigator.pop(context);
       updatinginvisit = false;
    }
      }
      
       else {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
       
        Navigator.pop(context);
         updatinginvisit = false;
      }
    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      
      Navigator.pop(context);
       updatinginvisit = false;
    }
  }

  Future<void> getactiveinvisits() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getallactiveinvisits";

    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        activeinvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        activeinvisits =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        notifyListeners();
      }
       else if (response.statusCode == 404) {
        print('No visits found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        print('No visits found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getpatientdiagnosis(String id, int visitindex) async {
  //   String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getindiagnosis/$id/$visitindex";
  //   print(url);
  //   // '${Constants.baseUrl}/app/log-in/phone-otp'
  //   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Constants.doctortoken}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print(responseData);
  //       invisitId = json.decode(response.body)['invisitId'];
  //       print(invisitId);
  //       patientdiagnosis =
  //           json.decode(response.body)['diagnosis'].cast<Map<String, dynamic>>();

  //       notifyListeners();
  //     } else if (response.statusCode == 404) {
  //       final responseData = jsonDecode(response.body);
  //       // print(responseData);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> getallpatientdiagnosis(String id, String complaintid) async {
  //   String url = "${Constants.baseUrl}/api/v1/hospitaldoctor/getalldiagnosis/$id/$complaintid";
  //   print(url);
  //   // '${Constants.baseUrl}/app/log-in/phone-otp'
  //   Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Constants.doctortoken}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print(responseData);
  //       // invisitId = json.decode(response.body)['invisitId'];
  //       // print(invisitId);
  //       patientalldiagnosis =
  //           json.decode(response.body)['data'].cast<Map<String, dynamic>>();

  //       notifyListeners();
  //     } else if (response.statusCode == 404) {
  //       final responseData = jsonDecode(response.body);
  //       // print(responseData);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }


Future<void> getalldoctorsdetails() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/getalldoctors";
    // '${Constants.baseUrl}/app/log-in/phone-otp'
    // Constants.token = await secureStorage.readSecureData('token') ?? '';
    
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        alldoctorsdetails =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
            print('alldoctorsdetails $alldoctorsdetails');

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        alldoctorsdetails =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();
            print('alldoctorsdetails $alldoctorsdetails');

        notifyListeners();
      } 
      else if (response.statusCode == 404) {
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

  String loginTime = '9:00';
  String logoutTime = "17:00";
  int duration = 30;
  String doctorname = '';

  bool isLoading = true;

  List<SlotModel> bookedSlots = [];
  List<SlotModel> finalSlots = [];

  /// ✅ 1. First load → fetch timing + booked today
  Future<void> loadInitialData(String userid, DateTime date) async {
   try{
     isLoading = true;
Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    

    final res = await http.get(
      Uri.parse(
        "${Constants.baseUrl}/api/v1/hospitaladmin/gettdayschedule/$userid?$date"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
        
        );

    final data = jsonDecode(res.body);
    print(data);
    doctorname = data["doctorName"];

    if(data["doctorTime"] == null){
      loginTime = '9:00';
      logoutTime = '17:00';
      duration = 30;
    //    loginTime = data["doctorTime"]["loginTime"];
    // logoutTime = data["doctorTime"]["leaveTime"];
    // duration = data["doctorTime"]["duration"];
    }
    else{
      // loginTime = '9:00';
      // logoutTime = '17:00';
      // duration = 30;
       loginTime = data["doctorTime"]["loginTime"];
    logoutTime = data["doctorTime"]["leaveTime"];
    duration = data["doctorTime"]["duration"];
    }

    bookedSlots = (data["slots"] as List)
        .map((e) => SlotModel.fromJson(e))
        .toList();

    generateSlots();

    isLoading = false;
    notifyListeners();
   }
   catch(e){
    isLoading = false;
    print("error: $e");
   }
  }

  /// ✅ 2. Date change → only slots API
  Future<void> loadByDate(DateTime date, String userid) async {
    try {
      isLoading = true;
    // notifyListeners();

    String d = DateFormat("dd-MM-yyyy").format(date);

    // Constants.token = await secureStorage.readSecureData('token') ?? '';
Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    

    final res = await http.get(Uri.parse(
        "${Constants.baseUrl}/api/v1/hospitaladmin/getschedulebydate/$userid?date=$d"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
        );

    final data = jsonDecode(res.body);
    print(data);
    
     if(data["doctorTime"] != null){
       loginTime = data["doctorTime"]["loginTime"];
    logoutTime = data["doctorTime"]["leaveTime"];
    duration = data["doctorTime"]["duration"];
    }
    else{
      loginTime = '9:00';
      logoutTime = "17:00";
      duration = 30;
    }

    bookedSlots = (data["slots"] as List)
        .map((e) => SlotModel.fromJson(e))
        .toList();


    generateSlots();

    isLoading = false;
    notifyListeners();
    } catch (e) {
      print("error : $e");
    }
  }

  // /// ✅ Generate all slots from timings + merge booked
  // void generateSlots() {
  //   finalSlots.clear();

  //   DateTime start = DateTime.parse("2024-01-01 $loginTime:00");
  //   DateTime end = DateTime.parse("2024-01-01 $logoutTime:00");

  //   while (start.isBefore(end)) {
  //     final s = DateFormat("HH:mm").format(start);
  //     final e = DateFormat("HH:mm").format(start.add(Duration(minutes: duration)));

  //     SlotModel slot = bookedSlots.firstWhere(
  //       (b) => b.startTime == s,
  //       orElse: () => SlotModel(startTime: s, endTime: e),
  //     );

  //     finalSlots.add(slot);
  //     start = start.add(Duration(minutes: duration));
  //   }
  // }

bool isSlotBooked(DateTime slotStart, DateTime slotEnd, List<SlotModel> bookedSlots) {
  for (final booked in bookedSlots) {
    final bookedStart = DateFormat("HH:mm").parse(booked.startTime);
    final bookedEnd = DateFormat("HH:mm").parse(booked.endTime);

    // OVERLAP CONDITION
    if (slotStart.isBefore(bookedEnd) && slotEnd.isAfter(bookedStart)) {
      return true;
    }
  }
  return false;
}



//   void generateSlots() {
//   final List<SlotModel> all = [];

//   // Parse login + logout times
//   final start = DateFormat("HH:mm").parse(loginTime);
//   final end = DateFormat("HH:mm").parse(logoutTime);

//   DateTime current = start;

//   while (current.isBefore(end)) {
//     final next = current.add(Duration(minutes: duration));

//     if (!next.isAfter(end)) {
//       bool booked = isSlotBooked(current, next, bookedSlots);


//       all.add(
//         SlotModel(
//           startTime: DateFormat("HH:mm").format(current),
//           endTime: DateFormat("HH:mm").format(next),
//           patientname: booked ? "BOOKED" : null,
//         ),
//       );
//     }

//     current = next;
//   }

//   finalSlots = all;
// }


void generateSlots() {
  List<SlotModel> all = [];

  final start = DateFormat("HH:mm").parse(loginTime);
  final end = DateFormat("HH:mm").parse(logoutTime);

  DateTime current = start;

  while (current.isBefore(end)) {
    final next = current.add(Duration(minutes: duration));
    if (!next.isAfter(end)) {

      // Check if this slot is already booked from backend
      SlotModel? matched;

      for (var b in bookedSlots) {
        final bStart = DateFormat("HH:mm").parse(b.startTime);
        final bEnd = DateFormat("HH:mm").parse(b.endTime);

        // Overlap check
        if (current.isBefore(bEnd) && next.isAfter(bStart)) {
          matched = b; // this booked slot matches the current slot
          break;
        }
      }

      // If matched = booked slot from backend → carry real mobile number
      all.add(
        matched ??
            SlotModel(
              startTime: DateFormat("HH:mm").format(current),
              endTime: DateFormat("HH:mm").format(next),
              patientname: null,
              patientMobile: "", // free slot → keep empty string
            ),
      );
    }

    current = next;
  }

  finalSlots = all;
}


  /// ✅ Book Slot API
  Future<void> bookSlot(String userid,
      SlotModel slot, DateTime date, String name, String mobile, BuildContext context) async {

    // Constants.token = await secureStorage.readSecureData('token') ?? '';
    
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
    
    final headers = await DeviceHeaders.getDeviceHeaders();


try{

    
final Map<String, dynamic> requestBody = {
         "bookingDate": DateFormat("dd-MM-yyyy").format(date),
      "startTime": slot.startTime,
      // "endTime": slot.endTime,
      "patientname": name,
      "patientMobile": mobile,
      };

      print(requestBody);

    final response = await http.post(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/slotbook/$userid"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers
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
              'Slot Booked successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      //  loadInitialData(userid);
 
  notifyListeners();

        // Navigator.pop(context);
      }else if(response.statusCode == 401){
        await refreshtoken();
          Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    final headers = await DeviceHeaders.getDeviceHeaders();
        try{
final Map<String, dynamic> requestBody = {
         "bookingDate": DateFormat("dd-MM-yyyy").format(date),
      "startTime": slot.startTime,
      // "endTime": slot.endTime,
      "patientname": name,
      "patientMobile": mobile,
      };

      print(requestBody);

    final response = await http.post(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/slotbook/$userid"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers
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
              'Slot Booked successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      //  loadInitialData(userid);
 
  notifyListeners();

        // Navigator.pop(context);
      }
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
        addingoutvisit = false;
      }
    
   } catch(e){
    print(e);
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }
      }
      
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
        addingoutvisit = false;
      }
    
   } catch(e){
    print(e);
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }


    // await http.post(
    //     Uri.parse("${Constants.baseUrl}/api/v1/admin/slotbook/$userid"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer ${Constants.token}',s
    //     },
    //     body: body);
  }

  /// ✅ Delete API
  Future<void> 
  deleteSlot(String userid,SlotModel slot, DateTime date, BuildContext context ) async {
        // Constants.token = await secureStorage.readSecureData('token') ?? '';

        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
        final headers = await DeviceHeaders.getDeviceHeaders();

    try{   
final Map<String, dynamic> requestBody = {
         "bookingDate": DateFormat("dd-MM-yyyy").format(date),
      "startTime": slot.startTime,
      "endTime": slot.endTime,
      };

    final response = await http.delete(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/deleteslot/$userid"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              responseData["msg"],
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

      //  loadInitialData(userid);
 
  notifyListeners();

        // Navigator.pop(context);
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
        final headers = await DeviceHeaders.getDeviceHeaders();
        try{   
final Map<String, dynamic> requestBody = {
         "bookingDate": DateFormat("dd-MM-yyyy").format(date),
      "startTime": slot.startTime,
      "endTime": slot.endTime,
      };

    final response = await http.delete(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/deleteslot/$userid"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              responseData["msg"],
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);

  notifyListeners();
      }
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
       
      }
    
   } catch(e){
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }
      }
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
       
      }
    
   } catch(e){
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }
   
  }
 

 Future<void> updateDoctorTiming(String doctorId, String login, String logout, int duration, DateTime date, BuildContext context) async {
  // Constants.token = await secureStorage.readSecureData('token') ?? '';
Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
final headers = await DeviceHeaders.getDeviceHeaders();

   try{ 
final Map<String, dynamic> requestBody = {
        "loginTime": login,
    "leaveTime": logout,
    "duration": duration,
    "date": formatDate(date.toString()),
      };

      print(requestBody);

    final response = await http.put(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/updatedoctortime/$doctorId"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addingoutvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Timing Updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        // loadInitialData(doctorId, date);
        loadByDate(date, doctorId);
       
 
  notifyListeners();

        // Navigator.pop(context);
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
final headers = await DeviceHeaders.getDeviceHeaders();
        try{ 
final Map<String, dynamic> requestBody = {
        "loginTime": login,
    "leaveTime": logout,
    "duration": duration,
    "date": formatDate(date.toString()),
      };

      print(requestBody);

    final response = await http.put(
        Uri.parse("${Constants.baseUrl}/api/v1/hospitaladmin/updatedoctortime/$doctorId"),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        addingoutvisit = false;
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Timing Updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        // loadInitialData(doctorId, date);
        loadByDate(date, doctorId);
       
 
  notifyListeners();

        // Navigator.pop(context);
      }
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
        addingoutvisit = false;
      }
    
   } catch(e){
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }
      }
      
       else {
        print(response.body);  
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        // Navigator.pop(context);
        addingoutvisit = false;
      }
    
   } catch(e){
    final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
   }

  
}

  Future<void> gettodaysappointments() async {
    String url = "${Constants.baseUrl}/api/v1/hospitaladmin/gettodaysappointments";

    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
       
        todaysappointments =
            json.decode(response.body)['appointments'].cast<Map<String, dynamic>>();
        print('todays appointments : $todaysappointments');

        notifyListeners();
      }else if(response.statusCode == 401){
        await refreshtoken();
        Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
        try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.admintoken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
       
        todaysappointments =
            json.decode(response.body)['appointments'].cast<Map<String, dynamic>>();
        print('todays appointments : $todaysappointments');

        notifyListeners();
      } else if (response.statusCode == 404) {
        print('No visits found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
      }
       else if (response.statusCode == 404) {
        print('No visits found');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> refreshtoken() async {
    try {
      Constants.adminrefreshtoken = await secureStorage.readSecureData('adminrefreshtoken') ?? '';
      // final headers = await DeviceHeaders.getDeviceHeaders();


      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/refreshtokenadminmobile'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.adminrefreshtoken}',
          'Content-Type': 'application/json',
          // ...headers,
        },
      );

      if (response.statusCode == 200) {
       print(response.body);
        final responseData = jsonDecode(response.body);
await secureStorage.writeSecureData('admintoken', responseData['token']);
        await secureStorage.writeSecureData('adminrefreshtoken', responseData['refreshToken']);
        await secureStorage.readSecureData('admintoken').then((value) {
          Constants.admintoken = value;
        });

  await secureStorage.readSecureData('adminrefreshtoken').then((value) {
          Constants.adminrefreshtoken = value;
        });
        print("Constants.admintoken ${Constants.admintoken}");
        print("Constants.adminrefreshtoken ${Constants.adminrefreshtoken}");


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
      Constants.adminrefreshtoken = await secureStorage.readSecureData('adminrefreshtoken') ?? '';


      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/hospitaladmin/logoutphone'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.adminrefreshtoken}',
          'Content-Type': 'application/json',
        },
      );
      print(response);
      invalidateCache();

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
