import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/complaintDialogBox.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/viewDiagnosisPage.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/downloadPdfButton.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/patientHistoryAi.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/supportingDocsDialogbox.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class PatientOutvisitsPage extends StatefulWidget {
  const PatientOutvisitsPage({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  State<PatientOutvisitsPage> createState() => _PatientOutvisitsPageState();
}

class _PatientOutvisitsPageState extends State<PatientOutvisitsPage> {
  late Future fetchoutvisits;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchoutvisits = doctorprovider.getpatientoutvisits(widget.patientId);
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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Patient OutVisit",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // title: Text(
        //       "${widget.name}",
        //       style: TextStyle(
        //         fontSize: 20,
        //         color: Colors.black,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       overflow: TextOverflow.ellipsis,
        //     ),

        // actions: [
        //    Text(
        //   widget.patientId,
        //   style: TextStyle(
        //     fontSize: 20,
        //     color: Colors.black,
        //   ),
        //    overflow: TextOverflow.ellipsis,
        // ),
        // SizedBox(width: 16,),

        // ],
      ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.blue, Colors.blue
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: ElevatedButton(
                              onPressed: () {
                                // Show the dialog
                          
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientHistoryAi(
                                        patientId: widget.patientId,
                                      ),
                                    ),
                                  );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person_add_alt_1_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 6),
                                  Text("AI Patient History",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: ElevatedButton(
                              onPressed: () {
                                // Show the dialog
                          
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RegisterVisitModel(
                                      patientId: widget.patientId,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person_add_alt_1_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 6),
                                  Text("Add OutVisit",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                      
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: fetchoutvisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show shimmer loading instead of CircularProgressIndicator
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.81,
                            child: _buildShimmerList(),
                          );
                        } else {
                          return SafeArea(
                            child: doctorprovider.patientoutvisits.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.81,
                                    child: const Center(
                                      child: Text(
                                        "No Outvisits for this pateint \nPlaese add Outvisit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.81,
                                    child: ListView.builder(
                                      itemCount: doctorprovider
                                          .patientoutvisits.length,
                                      itemBuilder: (context, index) {
                                        final item = doctorprovider
                                            .patientoutvisits[index];

                                        return VisitModel(
                                          visitnumber: index + 1,
                                          cheifcomplaint:
                                              item['chief_complaint'],
                                          visitdate:
                                              formatDate(item['visit_date']),
                                          complaintId: item['id'],
                                          patientId: widget.patientId,
                                          // createdtime: 'formatDate(complaint["createdAt"])',
                                          supportingimagesontap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return OutvisitSupportingFilesDialogBox(
                                                  patientId: widget.patientId,
                                                  complaintId: item["id"],
                                                );
                                              },
                                            );
                                          },
                                          viewontap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return VisitViewModel(
                                                  cheifcomplaint:
                                                      item["chief_complaint"],
                                                  height: item["height"] ?? "",
                                                  weight: item["weight"] ?? "",
                                                  bp: item["bp"] ?? "",
                                                  temprature:
                                                      item["temperature"] ?? "",
                                                  heartrate:
                                                      item["heart_rate"] ?? "",
                                                  visitdate: formatDate(
                                                      item["visit_date"]),
                                                );
                                              },
                                            );
                                          },
                                          startdiagnosisontap: () {
                                            context.router.push(DiagnosisRoute(
                                              patientId: widget.patientId,
                                              complaintId: item['id'],
                                            ));
                                          },
                                          buttonText:
                                              item['diagnosis_summary'] ?? '',
                                          remarkontap: () async {
                                            final remark = await doctorprovider
                                                .getdoctorremark(
                                                    widget.patientId,
                                                    item['id']);
                                            if (remark != null &&
                                                remark.isNotEmpty) {
                                              showDoctorRemarkDialog(
                                                context: context,
                                                htmlContent: remark,
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const Dialog(
                                                    insetPadding:
                                                        EdgeInsets.all(16),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 30),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              "There is no doctor remarks to show"),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.doctortoken =
        await secureStorage.readSecureData('doctortoken') ?? '';
    setState(() {
      fetchoutvisits = doctorprovider.getpatientoutvisits(widget.patientId);
    });
  }
}

// class VisitModel extends StatelessWidget {
//   const VisitModel({
//     super.key,
//     required this.cheifcomplaint,
//     required this.visitdate,
//     // required this.supportingimages,
//     // required this.createdtime,
//     // required this.supportingimaesontap,
//     required this.viewontap,
//     required this.buttonText,
//     required this.startdiagnosisontap,
//     required this.complaintId,
//     required this.patientId, required this.supportingimagesontap, required this.remarkontap,
//   });

//   final String cheifcomplaint;
//   final String visitdate;
//   // final List<dynamic> supportingimages;
//   final String complaintId;
//   final String patientId;

//   // final String createdtime;
//   final VoidCallback supportingimagesontap;
//   final VoidCallback viewontap;
//   final VoidCallback startdiagnosisontap;
//   final VoidCallback remarkontap;
//   final String buttonText;

//   @override
//   Widget build(BuildContext context) {
//     print(buttonText);
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//       ),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "Visit Date:",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         visitdate,
//                         style: TextStyle(
//                             fontSize: 14, color: Colors.grey.shade700),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                           onPressed: viewontap,
//                           icon: const Icon(
//                             Icons.remove_red_eye,
//                             color: Color(0Xff2556B9),
//                           )),
//                       IconButton(
//                           onPressed: supportingimagesontap,
//                           icon: const Icon(
//                             Icons.attach_file,
//                             color: Color(0Xff2556B9),
//                           )),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               const Text(
//                 "Cheif-Complaint :",
//                 style: TextStyle(
//                   fontSize: 16,
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
//                 style: const TextStyle(fontSize: 16),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               if (buttonText == "")
//                 ElevatedButton(
//                   onPressed: startdiagnosisontap,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                   ),
//                   child: const Text("Start Diagnosis",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       )),
//                 ),
//               if (buttonText != "")
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     DownloadPdfButton(
//                         complaintId: complaintId, patientId: patientId),
//                         ElevatedButton(onPressed:remarkontap ,
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF0857C0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                   ),
//                 child: const Text(
//                   "Remarks",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ))
//                   ],
//                 ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class VisitModel extends StatelessWidget {
  const VisitModel({
    super.key,
    required this.cheifcomplaint,
    required this.visitdate,
    required this.viewontap,
    required this.buttonText,
    required this.startdiagnosisontap,
    required this.complaintId,
    required this.patientId,
    required this.supportingimagesontap,
    required this.remarkontap,
    required this.visitnumber,
  });

  final String cheifcomplaint;
  final String visitdate;
  final String complaintId;
  final String patientId;
  final VoidCallback supportingimagesontap;
  final VoidCallback viewontap;
  final VoidCallback startdiagnosisontap;
  final VoidCallback remarkontap;
  final String buttonText;
  final int visitnumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// VISIT NUMBER
                const Text(
                  "VISIT NUMBER",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    " #${visitnumber.toString()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

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
                    fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                /// VIEW + EDIT
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: viewontap,
                        icon: const Icon(Icons.remove_red_eye,
                            color: AppColors.primary),
                        label: const Text(
                          "View",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: supportingimagesontap,
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: const Icon(Icons.attach_file,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// VIEW REPORT / DIAGNOSIS
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(12)),
                //     gradient:buttonText.isEmpty? LinearGradient(colors: [
                //       Colors.greenAccent.shade700,Colors.greenAccent
                //     ]): LinearGradient(colors: [
                //       Colors.blue,
                //       const Color.fromARGB(255, 76, 169, 246)
                //     ])
                //   ),
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: buttonText.isEmpty
                //         ? startdiagnosisontap
                //         : remarkontap,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.transparent,
                //       shadowColor: Colors.transparent,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(14),
                //       ),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //     ),
                //     child: Text(
                //       buttonText.isEmpty ? "Start Diagnosis" : "View Report",
                //       style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),

                if (buttonText == "")
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(colors: [
                       Colors.green, Colors.green.shade400 
                      ])
                    ),
                    child: ElevatedButton(
                      onPressed: startdiagnosisontap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text("Start Diagnosis",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                  ),

                if (buttonText != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DownloadPdfButton(
                            complaintId: complaintId, patientId: patientId),
                      ),
                      SizedBox(width: 16,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ElevatedButton(
                              onPressed: remarkontap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              child: const Text(
                                "Remarks",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      )
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

// class VisitViewModel extends StatelessWidget {
//   const VisitViewModel({
//     super.key,
//     required this.cheifcomplaint,
//     required this.height,
//     required this.weight,
//     required this.bp,
//     required this.temprature,
//     required this.heartrate,
//     required this.visitdate,
//   });

//   final String cheifcomplaint;
//   final String height;
//   final String weight;
//   final String bp;
//   final String temprature;
//   final String heartrate;
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
//             if (height != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Height: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${height}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//             if (weight != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Weight: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${weight}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//             if (temprature != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Temperature: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${temprature}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//             if (bp != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Blood Pressure: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${bp}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//             if (heartrate != "") ...[
//               Row(
//                 children: [
//                   const Text(
//                     "Heart Rate: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text("${heartrate}", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
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

class VisitViewModel extends StatelessWidget {
  const VisitViewModel({
    super.key,
    required this.cheifcomplaint,
    required this.height,
    required this.weight,
    required this.bp,
    required this.temprature,
    required this.heartrate,
    required this.visitdate,
  });

  final String cheifcomplaint;
  final String height;
  final String weight;
  final String bp;
  final String temprature;
  final String heartrate;
  final String visitdate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => context.router.pop(),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, size: 18, color: Colors.red),
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// TOP ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(height: 10),

            /// TITLE
            const Text(
              "Out-Visit Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            /// CHIEF COMPLAINT CARD
            _infoTile(
              icon: Icons.description_outlined,
              title: "CHIEF COMPLAINT",
              value: cheifcomplaint,
            ),

            const SizedBox(height: 12),

            /// VISIT DATE CARD
            _infoTile(
              icon: Icons.calendar_today_outlined,
              title: "VISIT DATE",
              value: visitdate,
            ),

            /// ⚠️ VITALS LOGIC KEPT (NOT REMOVED)
            if (height.isNotEmpty ||
                weight.isNotEmpty ||
                bp.isNotEmpty ||
                temprature.isNotEmpty ||
                heartrate.isNotEmpty)
              const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  /// INFO TILE WIDGET
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 16,
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

class RegisterVisitModel extends StatefulWidget {
  const RegisterVisitModel({
    super.key,
    required this.patientId,
  });
  final String patientId;

  @override
  State<RegisterVisitModel> createState() => _RegisterVisitModelState();
}

class _RegisterVisitModelState extends State<RegisterVisitModel> {
  final TextEditingController cheifcomplaintController =
      TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  final TextEditingController heartrateController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  DateTime today = DateTime.now();

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enter Complaint Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          context.router.pop();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Visit Date: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(formattedDate, style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  " Cheif Complaint* ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: cheifcomplaintController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // controller: _nameController,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(20),
                  //   FilteringTextInputFormatter.allow(
                  //     RegExp(r'[a-zA-Z0-9 ]'),
                  //   )
                  // ],
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cheif complaint';
                    }
                    return null; // Return null if validation is successful
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Cheif Complaint',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Vitals",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Height",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: heightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Height',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Weight",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: weightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Weight',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "BP",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: bpController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Blood Pressure',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Temperature",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: temperatureController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Temperature',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Heart Rate",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: heartrateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Heart Rate',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: doctorprovider.addingoutvisit
                        ? LinearGradient(colors: [Colors.grey, Colors.grey])
                        : AppColors.primaryGradient,
                  ),
                  child: ElevatedButton(
                    onPressed: doctorprovider.addingoutvisit
                        ? null
                        : () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                doctorprovider.addingoutvisit = true;
                              });
                              doctorprovider.addoutvisit(
                                widget.patientId,
                                cheifcomplaintController.text,
                                heartrateController.text,
                                weightController.text,
                                bpController.text,
                                temperatureController.text,
                                heartrateController.text,
                                context,
                              );

                              await doctorprovider
                                  .getpatientoutvisits(widget.patientId);
                            }

                            // context.router.pop();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doctorprovider.addingoutvisit
                          ? Colors.transparent
                          : Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: doctorprovider.addingoutvisit
                        ? CircularProgressIndicator()
                        : Text("Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
