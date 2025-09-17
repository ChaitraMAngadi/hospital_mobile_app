import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;


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
      } else {
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
      } else if (response.statusCode == 404) {
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
  print(Constants.admintoken);

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
      } else {
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
      } else {
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

      print(
          "name: $name gender: $gender DOB: $dob email: $email phone: $phone");

      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "DOB": dob,
        "phone": phone,
        "email": email,
      };

      // if (phone.isNotEmpty) {
      //   requestBody["memberphone"] = phone;
      // }

      // if (email.isNotEmpty) {
      //   requestBody["email"] = email;
      // }

      String url = "${Constants.baseUrl}/api/v1/hospitaladmin/editpatient/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.admintoken}',
          'Content-Type': 'application/json',
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
      } else if (response.statusCode == 404) {
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
      } else if (response.statusCode == 404) {
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
      } else {
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
      } else if (response.statusCode == 404) {
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
      } else if (response.statusCode == 404) {
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



void notify() {
    notifyListeners();
  }

}
