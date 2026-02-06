import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ImportPatientsPage extends StatefulWidget {
  const ImportPatientsPage({super.key});

  @override
  State<ImportPatientsPage> createState() => _ImportPatientsPageState();
}

class _ImportPatientsPageState extends State<ImportPatientsPage> {
   final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
    final TextEditingController otpController = TextEditingController();

    final requestFormKey = GlobalKey<FormState>();
        final validationformkey = GlobalKey<FormState>();
           bool _isLoading = false;



  late Future fetchallsharedpatients;
  final SecureStorage secureStorage = SecureStorage();

    late String formatedJoiDate;
    bool isotpsent = false;
    bool isloded = false;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchallsharedpatients = doctorprovider.getallsharedpatients().then((_) {
      setState(() {
        doctorprovider.filteredallsharedpatients = doctorprovider.allsharedpatients;
      });
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          // Reset to full list when search is cleared
          doctorprovider.filteredallsharedpatients = doctorprovider.allsharedpatients;
        } else {
          doctorprovider.filteredallsharedpatients =
              doctorprovider.allsharedpatients.where((visit) {
            final name = visit['name']?.toLowerCase() ?? '';
            final chiefcomplaint =
                visit['chief_complaint']?.toLowerCase() ?? '';
            final id = visit['patientId']?.toLowerCase() ?? '';
            return name.contains(query) ||
                id.contains(query) ||
                chiefcomplaint.contains(query);
          }).toList();
        }
      });
    });
  }

  // Future<void> _verifyOtp(String phone, String dob) async {
  //   if (!validationformkey.currentState!.validate()) return;
    
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     Doctorprovider doctorprovider = context.read<Doctorprovider>();
  //     await doctorprovider.verifyphoneOtp(
  //       phone,  
  //       dob,
  //       otpController.text,
  //       context
  //     );
     
  //   } catch (e) {
  //     // Handle error if needed
  //     print('Error verifying OTP: $e');
  //   } finally {
  //     // Always set loading to false when done
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _verifyOtp(String phone, String dob) async {
  if (!validationformkey.currentState!.validate()) return;
  
  setState(() {
    _isLoading = true;
  });

  try {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    await doctorprovider.verifyphoneOtp(
      phone,  
      dob,
      otpController.text,
      context
    );
    
    // After successful OTP verification, refresh the data
    if (mounted) {
      await _handleRefresh();
    }
   
  } catch (e) {
    // Handle error if needed
    print('Error verifying OTP: $e');
  } finally {
    // Always set loading to false when done
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


void _showOtpDialog(BuildContext context, String phone, String dob) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
           decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22)
            ),
          ),
          child: Column(
            children: [
               Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius:BorderRadius.vertical(top: Radius.circular(22))
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: validationformkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Enter OTP to verify",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OTP sent to $phone',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      PinCodeTextField(
                        appContext: context,
                        controller: otpController,
                        length: 6,
                        animationType: AnimationType.fade,
                        cursorColor: Colors.white,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter OTP';
                          }
                          if (value.length < 6) {
                            return 'Enter 6 digit OTP';
                          }
                          return null;
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 40,
                         activeFillColor: AppColors.badgeBg,
                          selectedColor: AppColors.accent,
                          inactiveColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  await _verifyOtp(phone, dob);
                                  if (mounted && !_isLoading) {
                                    Navigator.pop(context); 
                                    otpController.clear();
                                  }
                                },
                    //                    () async {
                    //                        Doctorprovider doctorprovider = context.read<Doctorprovider>();
                    // await doctorprovider.verifyphoneOtp(
                    //   phone,  
                    //   dob,
                    //   otpController.text,
                    //   context
                    // );
                    // Navigator.pop(context);
                    //                     },
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No search results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ElevatedButton(
              onPressed: () {
                _searchController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Clear Search',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Keep your existing shimmer methods
  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShimmerBox(width: 200, height: 32, borderRadius: 16),
              _buildShimmerBox(width: 60, height: 32, borderRadius: 16),
            ],
          ),
          SizedBox(height: 12),
          _buildShimmerBox(width: double.infinity, height: 18),
          SizedBox(height: 8),
          _buildShimmerBox(width: 200, height: 16),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
              _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
              _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(
      {required double width,
      required double height,
      double borderRadius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 1000 + (index * 100)),
          child: _buildShimmerItem(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Consumer<Doctorprovider>(
        builder: (context, doctorprovider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                           showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16))
                              ),
                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                              
                                children: [
                                  Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(22))
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Form(
                                      key: requestFormKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                        const Text(
                                                          "Request Patient Data",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.close),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            _phoneController.clear();
                                                            _dobController.clear();
                                                          },
                                                        ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            "Phone Number",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          TextFormField(
                                            controller: _phoneController,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                                        LengthLimitingTextInputFormatter(10),
                                                        FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            validator: (value) {
                                                        if (value!.length != 10) {
                                                          return 'Phone number must be exactly 10 digits';
                                                        }
                                                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                                          return 'Enter a valid phone number';
                                                        }
                                                        return null;
                                            },
                                            decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        hintText: 'Enter phone number',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Date of Birth',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        controller: _dobController,
                                                        readOnly: true,
                                                        decoration: InputDecoration(
                                                          suffixIcon: Padding(
                                                            padding: const EdgeInsets.only(right: 16),
                                                            child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now());
                                                        
                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formattedDate =
                                          DateFormat('dd/MM/yyyy').format(pickedDate);
                                      print(formattedDate);
                                      _dobController.text = formattedDate;
                                      formatedJoiDate =
                                          DateFormat('yyyy-MM-dd').format(pickedDate);
                                                        
                                      // setState(() {
                                      //   dob.text = formattedDate;
                                      // });
                                    } else {}
                                  },
                                  child: Icon(Icons.calendar_month_outlined)),
                                                          ),
                                                          border: OutlineInputBorder(),
                                                          hintText: 'Enter DOB',
                                                        ),
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please enter DOB';
                                                          }
                                                          return null; // Return null if validation is successful
                                                        },
                                            ),
                                          const SizedBox(height: 16),
                                          Container(
                                            
                                            decoration: BoxDecoration(
                                              gradient: AppColors.primaryGradient,
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:  Colors.transparent,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                                        ),
                                                        onPressed: () async {
                                                          if (requestFormKey.currentState!.validate()) {
                                                            final phone = _phoneController.text.trim();
                                                            final dob = formatedJoiDate;
                                                        
                                                        
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                                              ),
                                                            );
                                                        
                                                            if (phone == '8217309343' && dob == '1998-11-11') {
                                                          isloded = await doctorprovider.requsetdirectaccess(phone, dob, context);

                                                           if (mounted) Navigator.pop(context);
                                                              
                                                              // Close main dialog
                                                              if (mounted) Navigator.pop(context);
                                                              
                                                              // Clear controllers
                                                              _phoneController.clear();
                                                              _dobController.clear();
                                                              requestFormKey.currentState?.reset();
                                                              
                                                              // Refresh data if successful
                                                              if (isloded) {
                                  await _handleRefresh();
                                                              }
                                  //                        Navigator.pop(context); 
                                  //                        if (mounted && !isloded) {
                                  //   Navigator.pop(context); 
                                  //     _phoneController.clear();
                                  //                           _dobController.clear();
                                  // }
                                                          // if (isloded) {
                                                          //    Navigator.pop(context);
                                                            // _phoneController.clear();
                                                            // _dobController.clear();
                                                          //   requestFormKey.currentState?.reset();
                                                          //    fetchallsharedpatients =  doctorprovider.getallsharedpatients();
                                                          //   // patientpageprovider.notifyListeners(); // ✅ Refresh UI
                                                          // }
                                                        } else {
                                                          isotpsent = await doctorprovider.requsetaccess(phone, dob, context);
                                                          // Navigator.pop(context); // Close loading
                                                        
                                                        if (mounted) Navigator.pop(context);

                                                          if (isotpsent) {
                                                            // Navigator.pop(context); // Close main dialog
                                                                                              if (mounted) Navigator.pop(context);



                                                            _phoneController.clear();
                                                            _dobController.clear();
                                                            requestFormKey.currentState?.reset();
                                                            _showOtpDialog(context, phone, dob);
                                                          }
                                                        }
                                                        
                                                            // try {
                                                            //   Doctorprovider doctorprovider =
                                                            //       context.read<Doctorprovider>();
                                                            //   isotpsent = await doctorprovider.requsetaccess(
                                                            //       phone, dob, context);
                                                            //   Navigator.pop(context); // Close loading
                                                            //   if (isotpsent) {
                                                            //     Navigator.pop(context); // Close main dialog
                                                            //     _phoneController.clear();
                                                            //     _dobController.clear();
                                                            //     requestFormKey.currentState?.reset();
                                                            //     _showOtpDialog(context, phone, dob);
                                                            //   }
                                                            // } catch (e) {
                                                            //   Navigator.pop(context);
                                                            //   ScaffoldMessenger.of(context).showSnackBar(
                                                            //     SnackBar(content: Text('Error: ${e.toString()}')),
                                                            //   );
                                                            // }
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Submit",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                        },
                        // onPressed: () => context.router.push(RegisterPatientRoute()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                            SizedBox(width: 6),
                            Text("Request Access", style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                             color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Patient by id or name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: FutureBuilder(
                      future: fetchallsharedpatients,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: _buildShimmerList());
                        } else {
                          return SafeArea(
                            child: doctorprovider.filteredallsharedpatients.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.80,
                                    child: _searchController.text.isNotEmpty
                                        ? _buildNoSearchResults() // <-- show no results UI if searching
                                        : const Center(
                                            child: Text(
                                              "No Imported Patients to show",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.80,
                                    child: ListView.builder(
                                      itemCount: doctorprovider
                                          .filteredallsharedpatients.length,
                                      itemBuilder: (context, index) {
                                        final item = doctorprovider
                                            .filteredallsharedpatients[index];
                                        return ActiveInvisitModel(
                                          createdat: item["createdAt"],
                                          patientname: item['name'],
                                          patientId: item['patientId'],
                                          viewonTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ActiveInVisitViewModel(
                                                  name: item['name'],
                                                  id: item['patientId'],
                                                  gender: item['gender'],
                                                  phone:
                                                      item['phone'].toString(),
                                                  email: item['email'] ?? '',
                                                  age: item['age'],
                                                  dob: formatDate(item['DOB']),
                                                  createdbydoctor:
                                                      item['createdByDoctor']
                                                              ??
                                                          '',
                                              
                                                 
                                                  
                                                  
                                                  visitdate: formatDate(
                                                      item['createdAt']),
                                                  consultingdoctor:
                                                      item['doctorDetails']
                                                          ['name'],
                                                  // consultingdocid:
                                                  //     item['doctorDetails']
                                                  //         ['userid'],
                                                  
                                                );
                                              },
                                            );
                                          },
                                          startdiagnosisonTap: () {

                                            context.router.push(ImportedPatientsVisitRoute( patientId: item['patientId'],name:item['name'], ));
                                          },
                                          
                                         
                                        );
                                      },
                                    ),
                                  ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  Future<void> _handleRefresh() async {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.doctortoken =
        await secureStorage.readSecureData('doctortoken') ?? '';
    setState(() {
      fetchallsharedpatients = doctorprovider.getallsharedpatients();
      doctorprovider.filteredallsharedpatients = doctorprovider.allsharedpatients;
    });
  }
}

// class ActiveInvisitModel extends StatelessWidget {
//   const ActiveInvisitModel({
//     super.key,
//     required this.patientname,
//     required this.patientId,
//     required this.viewonTap,
//     required this.startdiagnosisonTap,
//   });
//   final String patientname;
//   final VoidCallback viewonTap;
//   final VoidCallback startdiagnosisonTap;
//   final String patientId;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 16,
//         left: 16,
//         right: 16,
//       ),
//       child: ListTile(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8))),
//         tileColor: Colors.grey.shade50,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       'PatientId: ',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Text(
//                       patientId,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                         onPressed: viewonTap,
//                         icon: const Icon(
//                           Icons.remove_red_eye_outlined,
//                           color: Color(0xFF0857C0),
//                         )),
//                     SizedBox(
//                       width: 6,
//                     ),
//                     Text(''),
//                   ],
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 const Text(
//                   'Name: ',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   patientname,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
            
           
//             const SizedBox(
//               height: 16,
//             ),

//             ElevatedButton(
//               onPressed: startdiagnosisonTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF0857C0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               ),
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.open_in_new,
//                     color: Colors.white,
//                   ),
//                   SizedBox(
//                     width: 6,
//                   ),
//                   Text("Visits",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white)),
//                 ],
//               ),
//             ),
//             // if (diagnosissummary != "")
//             // // Text("Download pdf button"),
//             //   DownloadPdfButton(complaintId: complaintId, patientId: patientId),

//             //    const SizedBox(
//             //   height: 16,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ActiveInvisitModel extends StatelessWidget {
  const ActiveInvisitModel({
    super.key,
    required this.patientname,
    required this.patientId,
    required this.viewonTap,
    required this.startdiagnosisonTap, required this.createdat,
  });
  final String patientname;
  final VoidCallback viewonTap;
  final VoidCallback startdiagnosisonTap;
  final String patientId;
  final String createdat;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22),top: Radius.circular(6)),
        border: Border.all(color: AppColors.accent),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Patient ID:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,          
                        ),),
                        const SizedBox(height: 6,),
                        Text(patientId,
                        style:  TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,          
                        ),),
                      ],
                    ),
              ),
              
             Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
               child: Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                       Text(
                    patientname,
                    style:  TextStyle(fontSize: 15,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4,),
                                 
                  const Text("Created:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),),
                  const SizedBox(height: 4),
                  Text(createdat,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),),
                  const SizedBox(height: 12),
                    ],
                  ),
                ),
               ),
             ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16),),
                          border: Border.all(color: AppColors.secondary),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent,),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.remove_red_eye_outlined, color: Colors.white,),
                              SizedBox(width: 6,),
                              Text("View",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),)
                            ],
                          ),
                          onPressed: viewonTap,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient: LinearGradient(colors: const [Color.fromARGB(255, 170, 244, 196),Color.fromARGB(255, 185, 250, 205)]),
                        border: Border.all(color: Colors.green,)
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.transparent,),
                          shadowColor: WidgetStatePropertyAll(Colors.transparent,),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.open_in_new,
                            color: Colors.green.shade800,
                            ),
                            SizedBox(width: 6,),
                            Text("Visits",
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),)
                          ],
                        ), onPressed: startdiagnosisonTap))),
                    
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20,)
        ],
      ),
      
    );
  }
}

// class ActiveInVisitViewModel extends StatelessWidget {
//   const ActiveInVisitViewModel({
//     super.key,
//     required this.visitdate,
//     required this.consultingdoctor,
//     required this.name,
//     required this.id,
//     required this.age,
//     required this.gender,
//     required this.dob,
//     required this.email,
//     required this.phone,
//     required this.createdbydoctor,
//   });

//   final String name;
//   final String id;
//   final String age;
//   final String gender;
//   final String dob;
//   final String email;
//   final String phone;
//   final String createdbydoctor;
//   final String consultingdoctor;
//   final String visitdate;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//   insetPadding: const EdgeInsets.symmetric(horizontal: 16),
//   child: Padding(
//     padding: const EdgeInsets.all(16),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Top bar
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Patient Details",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               onPressed: () => context.router.pop(),
//               icon: const Icon(Icons.close),
//             ),
//           ],
//         ),

//         const SizedBox(height: 10),

//         // Now stack all detail rows vertically
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Patient Name: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(name)),
//           ],
//         ),
//         SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Patient Id: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(id),
//           ],
//         ),
//          SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Age: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(age)),
//           ],
//         ),
//          SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Gender: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(gender)),
//           ],
//         ),
//          SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Phone: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(phone)),
//           ],
//         ),
//          SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Date of Birth: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(dob)),
//           ],
//         ),
//          SizedBox(height: 4,),
//          if(email.isNotEmpty)
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Email: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text(email)),
//           ],
//         ),
//         if(email.isNotEmpty)
//          SizedBox(height: 4,),

//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Consulting Doctor: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Flexible(child: Text("$consultingdoctor")),
//           ],
//         ),
        
//          SizedBox(height: 4,),
//         Row(
//           children: [
//             const Text("Visit Date: ",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(visitdate),
//           ],
//         ),
//       ],
//     ),
//   ),
// );
//   }
// }


class ActiveInVisitViewModel extends StatelessWidget {
  const ActiveInVisitViewModel({
    super.key,
    required this.visitdate,
    required this.consultingdoctor,
    required this.name,
    required this.id,
    required this.age,
    required this.gender,
    required this.dob,
    required this.email,
    required this.phone,
    required this.createdbydoctor,
  });

  final String name;
  final String id;
  final String age;
  final String gender;
  final String dob;
  final String email;
  final String phone;
  final String createdbydoctor;
  final String consultingdoctor;
  final String visitdate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius:BorderRadiusGeometry.vertical(top: Radius.circular(10),bottom: Radius.circular(22))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22))
          ),),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 4
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person, color: Colors.red),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Patient Details",
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.router.pop(),
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 16),
          
                  /// NAME (Highlighted)
                  _highlightTile(
                    icon: Icons.person,
                    label: "NAME",
                    value: name,
                  ),
          
                  const SizedBox(height: 12),
          
                  /// EMAIL
                  if (email.isNotEmpty)
                    _infoTile(
                      icon: Icons.email,
                      label: "EMAIL",
                      value: email,
                      iconBg: Colors.blue.shade50,
                      iconColor: Colors.blue,
                    ),
          
                  if (email.isNotEmpty) const SizedBox(height: 12),
          
                  /// PHONE
                  _infoTile(
                    icon: Icons.phone,
                    label: "PHONE NUMBER",
                    value: phone,
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                  ),
          
                  const SizedBox(height: 16),
                  _divider(),
          
                  /// DOB + AGE
                  Row(
                    children: [
                      Expanded(
                        child: _smallTile(
                          label: "DOB",
                          value: dob,
                          icon: Icons.cake,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _smallTile(
                          label: "AGE",
                          value: age,
                          icon: Icons.person_outline,
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 12),
          
                  /// PATIENT ID + GENDER
                  Row(
                    children: [
                      Expanded(
                        child: _smallTile(
                          label: "PATIENT ID",
                          value: id,
                          icon: Icons.tag,
                          valueColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _smallTile(
                          label: "GENDER",
                          value: gender,
                          icon: Icons.wc,
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 16),
          
                  /// CREATED BY DOCTOR
                  _highlightTile(
                    icon: Icons.medical_services,
                    label: "CREATED BY DOCTOR",
                    value: createdbydoctor,
                  ),
          
                  const SizedBox(height: 12),
          
                  /// CONSULTING DOCTOR
                  _infoTile(
                    icon: Icons.person_pin,
                    label: "CONSULTING DOCTOR",
                    value: consultingdoctor,
                    iconBg: Colors.red.shade50,
                    iconColor: Colors.red,
                  ),
          
                  const SizedBox(height: 12),
          
                  /// VISIT DATE
                  _infoTile(
                    icon: Icons.calendar_today,
                    label: "VISIT DATE",
                    value: visitdate,
                    iconBg: Colors.grey.shade100,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Divider
  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.red.shade200,
    );
  }

  /// Highlight Card
  Widget _highlightTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                       TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Info Card
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                       TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Small Tile
  Widget _smallTile({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryDark),
              const SizedBox(width: 6),
              Text(label,
                  style:
                       TextStyle(fontSize: 12,
                       fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}