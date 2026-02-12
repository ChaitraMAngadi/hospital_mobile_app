import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/complaintDialogBox.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class PatientInvisitsPage extends StatefulWidget {
  final String patientId;
  final String name;
  const PatientInvisitsPage({super.key, required this.patientId, required this.name});

  @override
  State<PatientInvisitsPage> createState() => _PatientInvisitsPageState();
}

class _PatientInvisitsPageState extends State<PatientInvisitsPage> {
  late Future fetchPatientInvisits;
  late Future fetchalldoctorsnurses;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchPatientInvisits = doctorprovider.getpatientinvisits(widget.patientId);
    fetchalldoctorsnurses = doctorprovider.getdoctorsnurses();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          _buildShimmerBox(width: double.infinity, height: 18),
          const SizedBox(height: 8),
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
          appBar: AppBar(
               flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,
        color: Colors.white,)),
            title:  Text(
              "${widget.name}'s InVisit",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Consumer<Doctorprovider>(
            builder:(context, doctorprovider, child) {
            return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: Container(
                        decoration:BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ) ,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24)),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                            context: context,
                                            builder: (context) =>  ComplaintDialog(
                                        alldoctors: doctorprovider.alldoctors,
                                        allnurses: doctorprovider.allnurses,
                                        patientId: widget.patientId,
                                            ),
                                          );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_add_alt_1_outlined,
                                  color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Add IPD visit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FutureBuilder(
                      future: fetchPatientInvisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height*0.76,
                              child: _buildShimmerList());
                        } else {
                          return SafeArea(
                              child: doctorprovider.patientinvisits.isEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height*0.76,
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          "No Invisits for this pateint \nPlaese add Invisit",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )))
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height*0.76,
                                      child: ListView.builder(
                                        itemCount: doctorprovider
                                            .patientinvisits.length,
                                        itemBuilder: (context, index) {
                                          final item = doctorprovider
                                              .patientinvisits[index];
                
                                          return InVisitModel(visitnumber: index+1,
                                              cheifcomplaint:
                                                  item['chief_complaint'],
                                              visitdate: formatDate(
                                                  item['visit_date']),
                                              viewontap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return InVisitViewModel(
                                                        cheifcomplaint: item[
                                                            'chief_complaint'],
                                                        visitdate: formatDate(
                                                            item['visit_date']),
                                                        consultingdoctor: item[
                                                                'consultingDoctor']
                                                            ['name'],
                                                        dutydoctor:
                                                            item['dutyDoctor']?
                                                                ['name']??'',
                                                        visitingdoctor: item[
                                                                'visitingDoctor']?
                                                            ['name']??'',
                                                        associatedstaff: item[
                                                                'associatedNurse']?
                                                            ['name']??'');
                                                  },
                                                );
                                              },
                                              diagnosisontap: () {
                                                context.router.push(
                                                  ViewDiagnosisRoute(name: widget.name, 
                                                id: widget.patientId, visitingIndex: item['visit_index'], dischargeddate: item['discharged_date']??'',
                                                )
                                                
                                                );
                                              },
                                              observationontap: () {},
                                              dischargedate:
                                                  item['discharged_date'] ??
                                                      '');
                                        },
                                      ),
                                    ));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
          },),
        );
    
  }

  Future<void> _handleRefresh() async {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.doctortoken =
        await secureStorage.readSecureData('doctortoken') ?? '';
    setState(() {
      fetchPatientInvisits =
          doctorprovider.getpatientinvisits(widget.patientId);
    });
  }
}

// class InVisitModel extends StatelessWidget {
//   const InVisitModel({
//     super.key,
//     required this.cheifcomplaint,
//     required this.visitdate,
//     required this.viewontap,
//     required this.diagnosisontap,
//     required this.observationontap,
//     required this.dischargedate,
//   });

//   final String cheifcomplaint;
//   final String visitdate;
//   final VoidCallback viewontap;
//   final VoidCallback diagnosisontap;
//   final VoidCallback observationontap;
//   final String dischargedate;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//       ),
//       child: Card(
//         child: Padding(
//           padding:
//               const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     visitdate,
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                         color: dischargedate == ""
//                             ? Colors.green.shade400
//                             : Colors.red.shade400),
//                     child: Text(
//                       dischargedate == "" ? "Active" : "Discharged",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               const Text(
//                 "Cheif-Complaint :",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               Text(
//                 cheifcomplaint,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.black,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                       onPressed: viewontap,
//                       icon: const Icon(
//                         Icons.remove_red_eye,
//                         color: Color(0Xff2556B9),
//                       )),
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple.shade100,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                       onPressed: diagnosisontap,
//                       child: Row(
//                         children: [
//                           Text(
//                             "Diagnosis",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple.shade700,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 4,
//                           ),
//                           Icon(
//                             Icons.open_in_new,
//                             color: Colors.deepPurple.shade700,
//                           ),
//                         ],
//                       )),
//                   // ElevatedButton(
//                   //     style: ElevatedButton.styleFrom(
//                   //       backgroundColor: Colors.deepPurple.shade100,
//                   //       shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(20),
//                   //       ),
//                   //       padding:
//                   //           EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                   //     ),
//                   //     onPressed: observationontap,
//                   //     child: Row(
//                   //       children: [
//                   //         Text(
//                   //           "Observations",
//                   //           style: TextStyle(
//                   //             fontWeight: FontWeight.bold,
//                   //             color: Colors.deepPurple.shade700,
//                   //           ),
//                   //         ),
//                   //         SizedBox(
//                   //           width: 4,
//                   //         ),
//                   //         Icon(
//                   //           Icons.open_in_new,
//                   //           color: Colors.deepPurple.shade700,
//                   //         ),
//                   //       ],
//                   //     ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class InVisitModel extends StatelessWidget {
  const InVisitModel({
    super.key,
    required this.cheifcomplaint,
    required this.visitdate,
    required this.viewontap,
    required this.diagnosisontap,
    required this.observationontap,
    required this.dischargedate, required this.visitnumber,
  });

  final String cheifcomplaint;
  final String visitdate;
  final VoidCallback viewontap;
  final VoidCallback diagnosisontap;
  final VoidCallback observationontap;
  final String dischargedate;
  final int visitnumber;

  @override
  Widget build(BuildContext context) {
    final bool isActive = dischargedate.isEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
     
      decoration: BoxDecoration(
        color: Colors.white,
         borderRadius: BorderRadius.vertical(
            top: Radius.circular(12), bottom: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
Container(
  height: 4,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    gradient: AppColors.primaryGradient,
  ),
),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  Text(
                        "#${visitnumber.toString()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.greenAccent.shade400
                            : Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? "Active" : "Discharged",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 16),
            
                /// CHIEF COMPLAINT
                const Text(
                  "CHIEF COMPLAINT",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cheifcomplaint,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 14),
            
                /// VISIT DATE
                const Text(
                  "VISIT DATE",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  visitdate,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 20),
            
                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: viewontap,
                          icon: const Icon(Icons.remove_red_eye,
                              color: Colors.white),
                          label: const Text(
                            "View",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: diagnosisontap,
                        icon: const Icon(Icons.open_in_new, color: Colors.white),
                        label: const Text(
                          "Diagnosis",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A86F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// class TodaysVisitViewModel extends StatelessWidget {
//   const TodaysVisitViewModel({
//     super.key,
//     required this.createdat,
//     required this.cheifcomplaint,
//     required this.visitdate,
//     required this.name,
//     required this.patientId,
//     required this.age,
//     required this.gender,
//     required this.phone,
//     required this.dob,
//     required this.email,
//   });

//   final String cheifcomplaint;
//   final String name;
//   final String patientId;
//   final String age;
//   final String gender;
//   final int phone;
//   final String dob;
//   final String email;
//   final String visitdate;
//   final String createdat;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Details",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       context.router.pop();
//                     },
//                     icon: const Icon(Icons.close))
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Patient name: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${name}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Patient Id: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${patientId}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Age : ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${age}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Gender: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${gender}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Phone Number: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${phone.toString()}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Date of Birth: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${dob}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             if (email != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Email: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${email}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//             ],
//             SizedBox(
//               height: 20,
//             ),
//             const Text(
//               "Complaint Details",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//             SizedBox(
//               height: 14,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   " Chief Complaint: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                   child: Text(
//                     "$cheifcomplaint",
//                     style: const TextStyle(fontSize: 14),
//                     softWrap: true,
//                   ),
//                 ),
//                 // Text("${cheifcomplaint}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Creation Time: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${createdat}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class TodaysVisitViewModel extends StatelessWidget {
  const TodaysVisitViewModel({
    super.key,
    required this.createdat,
    required this.cheifcomplaint,
    required this.visitdate,
    required this.name,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.phone,
    required this.dob,
    required this.email,
  });

  final String cheifcomplaint;
  final String name;
  final String patientId;
  final String age;
  final String gender;
  final int phone;
  final String dob;
  final String email;
  final String visitdate;
  final String createdat;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TOP ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            const Text(
              "In-Visit Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: 20),

            /// CHIEF COMPLAINT
            _detailTile(
              icon: Icons.medical_information,
              title: "CHIEF COMPLAINT",
              value: cheifcomplaint,
            ),

            const SizedBox(height: 14),

            /// CONSULTING DOCTOR (using patient name as per available data)
            _detailTile(
              icon: Icons.person,
              title: "CONSULTING DOCTOR",
              value: name,
            ),

            const SizedBox(height: 14),

            /// VISIT DATE
            _detailTile(
              icon: Icons.calendar_month,
              title: "VISIT DATE",
              value: visitdate,
            ),

            const SizedBox(height: 10),

            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REUSABLE TILE
  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class InVisitViewModel extends StatelessWidget {
//   const InVisitViewModel({
//     super.key,
//     required this.cheifcomplaint,
//     required this.visitdate,
//     required this.consultingdoctor,
//     required this.dutydoctor,
//     required this.visitingdoctor,
//     required this.associatedstaff,
//   });

//   final String cheifcomplaint;
//   final String consultingdoctor;
//   final String dutydoctor;
//   final String visitingdoctor;
//   final String associatedstaff;
//   final String visitdate;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Complaint Details",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       context.router.pop();
//                     },
//                     icon: const Icon(Icons.close))
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Chief Complaint: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                   child: Text(
//                     "$cheifcomplaint",
//                     style: const TextStyle(fontSize: 14),
//                     softWrap: true,
//                   ),
//                 ),
//                 // Text(
//                 //   "${cheifcomplaint}",
//                 //   style: TextStyle(fontSize: 14),

//                 // ),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Consulting Doctor: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                     child: Text(
//                   consultingdoctor,
//                   style: TextStyle(fontSize: 14),
//                   softWrap: true,
//                 )),
//               ],
//             ),
//             if(visitingdoctor.isNotEmpty)
//             const SizedBox(
//               height: 8,
//             ),
//             if(visitingdoctor.isNotEmpty)
//             Row(
//               children: [
//                 const Text(
//                   "Visiting Doctor: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                     child: Text(
//                   visitingdoctor,
//                   style: TextStyle(fontSize: 14),
//                   softWrap: true,
//                 )),
//               ],
//             ),
//             if(dutydoctor.isNotEmpty)
//             const SizedBox(
//               height: 8,
//             ),
//             if(dutydoctor.isNotEmpty)
//             Row(
//               children: [
//                 const Text(
//                   "Duty Doctor: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                     child: Text(
//                   dutydoctor,
//                   style: TextStyle(fontSize: 14),
//                   softWrap: true,
//                 )),
//               ],
//             ),
//             if(associatedstaff.isNotEmpty)
//             const SizedBox(
//               height: 8,
//             ),
//             if(associatedstaff.isNotEmpty)
//             Row(
//               children: [
//                 const Text(
//                   "Associated Staff: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                     child: Text(
//                   associatedstaff,
//                   style: TextStyle(fontSize: 14),
//                   softWrap: true,
//                 )),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Visit Date: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${visitdate}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             // Row(
//             //   children: [
//             //     const Text(
//             //       "Creation Time: ",
//             //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             //     ),
//             //     Text("${createdat}", style: TextStyle(fontSize: 14)),
//             //   ],
//             // ),
//             // const SizedBox(
//             //   height: 8,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class InVisitViewModel extends StatelessWidget {
  const InVisitViewModel({
    super.key,
    required this.cheifcomplaint,
    required this.visitdate,
    required this.consultingdoctor,
    required this.dutydoctor,
    required this.visitingdoctor,
    required this.associatedstaff,
  });

  final String cheifcomplaint;
  final String consultingdoctor;
  final String dutydoctor;
  final String visitingdoctor;
  final String associatedstaff;
  final String visitdate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.primaryDark),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            /// TOP ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            const Text(
              "In-Visit Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: 20),

            /// CHIEF COMPLAINT
            _detailTile(
              icon: Icons.medical_information,
              title: "CHIEF COMPLAINT",
              value: cheifcomplaint,
            ),

            const SizedBox(height: 14),

            /// CONSULTING DOCTOR
            _detailTile(
              icon: Icons.person,
              title: "CONSULTING DOCTOR",
              value: consultingdoctor,
            ),

            if (visitingdoctor.isNotEmpty) ...[
              const SizedBox(height: 14),
              _detailTile(
                icon: Icons.person_outline,
                title: "VISITING DOCTOR",
                value: visitingdoctor,
              ),
            ],

            if (dutydoctor.isNotEmpty) ...[
              const SizedBox(height: 14),
              _detailTile(
                icon: Icons.person_2_outlined,
                title: "DUTY DOCTOR",
                value: dutydoctor,
              ),
            ],

            if (associatedstaff.isNotEmpty) ...[
              const SizedBox(height: 14),
              _detailTile(
                icon: Icons.groups,
                title: "ASSOCIATED STAFF",
                value: associatedstaff,
              ),
            ],

            const SizedBox(height: 14),

            /// VISIT DATE
            _detailTile(
              icon: Icons.calendar_month,
              title: "VISIT DATE",
              value: visitdate,
            ),
          ],
        ),
      ),
    );
  }

  /// REUSABLE DETAIL CARD
  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
