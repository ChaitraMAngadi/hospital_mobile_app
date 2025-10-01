import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future fetchdoctorprofile;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchdoctorprofile = doctorprovider.getdoctordetailedprofile();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    // SecureStorage secureStorage = SecureStorage();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: fetchdoctorprofile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerList();
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error fetching data"));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: doctorprovider.doctordetailedprofile.length,
                        itemBuilder: (context, index) {
                          final item =
                              doctorprovider.doctordetailedprofile[index];
                          final hospitalbranch =
                              item['associatedHospitalBranch'];
                          final hospital = hospitalbranch['associatedHospital'];

                          return
                              // Text('profile');
                              Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                //                       Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: [
                                //                           const SizedBox(),
                                //                           ElevatedButton(
                                //                             style:  ButtonStyle(
                                //   padding: const WidgetStatePropertyAll(
                                //       EdgeInsets.symmetric(vertical: 14, horizontal: 20)),
                                //   backgroundColor: WidgetStatePropertyAll(Colors.green.shade400,),
                                //   shape: const WidgetStatePropertyAll(
                                //     RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.all(Radius.circular(14)),
                                //     ),
                                //   ),
                                // ),
                                //                             onPressed: (){

                                //                               showDialog(
                                //                                 context: context,
                                //                                 builder: (context) {
                                //                                   return ResetPasswordModel();
                                //                                 },
                                //                               );
                                //                             },
                                //                             child: const Text("Reset Password",
                                //                           style: TextStyle(
                                //                             fontWeight: FontWeight.bold,
                                //                             fontSize: 16,
                                //                             color: Colors.white,
                                //                           ),))
                                //                         ],
                                //                       ),
                                //  const SizedBox(height: 16,),

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text("Doctor Profile",
                                //         style: TextStyle(
                                //           fontSize: 22,
                                //           fontWeight: FontWeight.bold,
                                //         )),
                                //     Text(
                                //       "Valid Date: ${formatDate(item['validity'])}",
                                //       style: const TextStyle(
                                //         fontSize: 16,
                                //       ),
                                //     )
                                //   ],
                                // ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                          "My Details",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo.shade700),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
     crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            const Text(
                                              "Name: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  
                                                  // overflow: TextOverflow.ellipsis,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "ID: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['userid'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['email'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Phone: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['phone'].toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Gender: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['gender'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Registration Number: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['doctorRegistrationNumber'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Board of Registration: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['board_of_registration'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Qualification: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['qualification'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Specialization: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['specialization'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Address: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['address'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         const Text(
                                          "Associated Hospital Branch",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 26, 136, 83),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "ID: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              hospitalbranch['userid'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Name: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                hospitalbranch['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Address: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                hospitalbranch['address'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                                // maxLines: 2,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['email'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                                // maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Phone: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item['phone'].toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          "Associated Hospital",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple.shade700
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "ID: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              hospital['userid'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Name: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                item['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                                // maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                hospital['email'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                                // maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0857C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () async {
                    secureStorage.deleteSecureData('token');
                    secureStorage.deleteSecureData('doctortoken');
                    secureStorage.deleteSecureData('admintoken');
                    secureStorage.deleteSecureData('nursetoken');

                    setState(() {});
                    Constants.token =
                        await secureStorage.readSecureData('token') ?? '';
                    Constants.doctortoken =
                        await secureStorage.readSecureData('doctortoken') ?? '';
                    Constants.admintoken =
                        await secureStorage.readSecureData('admintoken') ?? '';
                    Constants.nursetoken =
                        await secureStorage.readSecureData('nursetoken') ?? '';
                    context.router.replaceAll([const LoginRoute()]);
                    // homePageProvider.selectedIndex = 0;
                    // homePageProvider.notify();
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),

                  const SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //  Widget _buildShimmerLoading() {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.74,
  //     child: ListView.builder(
  //       itemCount: 4, // Show 8 shimmer items
  //       itemBuilder: (context, index) {
  //         return _buildShimmerItem();
  //       },
  //     ),
  //   );
  // }

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
          // _buildShimmerBox(width: double.infinity, height: 18),
          // SizedBox(height: 8),
          // _buildShimmerBox(width: 200, height: 16),
          // SizedBox(height: 4),

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
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 1000 + (index * 100)),
          child: _buildShimmerItem(),
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.doctortoken =
        await secureStorage.readSecureData('doctortoken') ?? '';
    setState(() {
      fetchdoctorprofile = doctorprovider.getdoctordetailedprofile();
    });
  }
}

// class ResetPasswordModel extends StatelessWidget {
//   const ResetPasswordModel({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool _obscureText = true;
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController confirmController = TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//         HomePageProvider homePageProvider = context.read<HomePageProvider>();

//     return Dialog(insetPadding: EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                  const Text("Reset Password",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),),
//                   IconButton(onPressed: (){
//                     Navigator.pop(context);
//                   }, icon: Icon(Icons.close))
//                 ],
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//              const Text("New Password",
//               style:TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold
//               ) ,),
//               SizedBox(height: 4,),
//               TextFormField(
//                                   obscureText: _obscureText,
//                                   controller: passwordController,
//                                   cursorColor: const Color(0Xff2556B9),

//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please enter password';
//                                     }

//                                     return null; // Return null if validation is successful
//                                   },
//                                   decoration: InputDecoration(
//                                       focusedBorder: const OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.all(Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                       ),

//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey.shade400,
//                                         ),
//                                       ),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 16, top: 14, bottom: 14),
//                                       border: OutlineInputBorder(
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey.shade400,
//                                         ),
//                                       ),
//                                       hintText: 'Enter password',
//                                       hintStyle: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: const Color(0xff333333)
//                                               .withOpacity(0.5))),
//                                 ),

//                                 SizedBox(
//                                   height: 16,
//                                 ),
//              const Text("Confirm Password",
//               style:TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold
//               ) ,),
//               SizedBox(height: 4,),
//               TextFormField(

//                                   controller: confirmController,
//                                   cursorColor: const Color(0Xff2556B9),

//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please enter confirm password';
//                                     }
//                                     else if(passwordController.text != value){
//                                       return 'Passwords do not match';
//                                     }

//                                     return null; // Return null if validation is successful
//                                   },
//                                   decoration: InputDecoration(
//                                       focusedBorder: const OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.all(Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                       ),

//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey.shade400,
//                                         ),
//                                       ),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 16, top: 14, bottom: 14),
//                                       border: OutlineInputBorder(
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(5)),
//                                         borderSide: BorderSide(
//                                           color: Colors.grey.shade400,
//                                         ),
//                                       ),
//                                       hintText: 'Confirm password',
//                                       hintStyle: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: const Color(0xff333333)
//                                               .withOpacity(0.5))),
//                                 ),

//                                 SizedBox(
//                                   height: 16,
//                                 ),
//                                  SizedBox(
//                                   width: double.infinity,
//                                    child: ElevatedButton(
//                                      style: const ButtonStyle(

//             backgroundColor: WidgetStatePropertyAll(Color(0XFF0857C0)),
//             padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12,)),
//             shape: WidgetStatePropertyAll(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(14)),
//               ),
//             ),
//           ),
//                                            onPressed: () {
//                                              if (_formKey.currentState!.validate()) {
//                                                // Proceed with submission
//                                                print("Passwords match and form is valid.");
//                                                homePageProvider.changepassword(confirmController.text, context);

//                                              }
//                                            },
//                                            child:const Text('Submit',
//                                            style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                            ),),
//                                          ),
//                                  ),
//                                  SizedBox(height: 16,),
//               // TextFormField(),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
