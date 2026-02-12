import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/dischargeDialogBox.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/dischargePdfViewReport.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/downloadInvisitPdfButton.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/inpatientHistoryAi.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/invistSupportingDialogBox.dart';
import 'package:hospital_mobile_app/doctorController/pdfViewPage.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../routes/app_router.dart';

@RoutePage()
class ViewDiagnosisPage extends StatefulWidget {
  final String name;
  final String id;
  final int visitingIndex;
  final String dischargeddate;

  const ViewDiagnosisPage({
    super.key,
    required this.name,
    required this.id,
    required this.visitingIndex,
    required this.dischargeddate,
  });

  @override
  State<ViewDiagnosisPage> createState() => _ViewDiagnosisPageState();
}

class _ViewDiagnosisPageState extends State<ViewDiagnosisPage> {
  late Future fetchpatientdiagnosis;
  late Future fetchalldiagnosis;
  late Future fetchallobservations;
  late String invisitId;

  final SecureStorage secureStorage = SecureStorage();


  @override
  void initState() {
    super.initState();
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchpatientdiagnosis =
        doctorprovider.getpatientdiagnosis(widget.id, widget.visitingIndex);
    invisitId = doctorprovider.invisitId;

    fetchalldiagnosis = doctorprovider.getallpatientdiagnosis(
        widget.id, doctorprovider.invisitId);
    fetchallobservations =
        doctorprovider.getallobservations(widget.id, doctorprovider.invisitId);
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
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
    Doctorprovider doctorprovider = context.watch<Doctorprovider>();
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
          title: Text(
            '${widget.name}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                
              ),
              child: ElevatedButton(
               style:  ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 14)),
                                  backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                                      shadowColor:WidgetStatePropertyAll(Colors.transparent),
                                  shape: const WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                ),
                onPressed: doctorprovider.patientdiagnosis.isEmpty? null :(){
                  print(widget.id);
                 print(doctorprovider.invisitId);
 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientInHistoryAi(
                                        patientId: widget.id,
                                       id: doctorprovider.invisitId,
                                      ),
                                    ),
                                  );
                }, 
                child: Row(
                  children: [
                     const Icon(Icons.file_copy_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 6),
                    Text("Patient AI History",
                    style: TextStyle(
                      color:doctorprovider.patientdiagnosis.isEmpty?Colors.grey: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                )),
            )
          ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                        child: Row(
                          
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(widget.dischargeddate == '')
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                      context: context,
                                      builder: (context) {
                                        print(doctorprovider.invisitId);
                                        return DischargeDialogBox(patientId: widget.id, complaintId: doctorprovider.invisitId);
                                      },
                                    );
                                // context.router.push(RegisterPatientRoute());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              child: Text("Discharge",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                            ),
                            // SizedBox(width: 8,),
                                          
                            if(widget.dischargeddate != '')
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DischargePdfViewerPage(
                                 patientId: widget.id,
                                    complaintId: doctorprovider.invisitId,
                                ),
                              ),
                            ),
                              // onPressed: () {
                                // showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         print(doctorprovider.invisitId);
                                //         return DischargeDialogBox(patientId: widget.id, complaintId: doctorprovider.invisitId);
                                //       },
                                //     );
                                // context.router.push(RegisterPatientRoute());
                              // },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              child: Text("Discharge Report",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                            ),
                                          //  SizedBox(width: 8,),
                            if(widget.dischargeddate == '')
                            ElevatedButton(
                              onPressed: () {
                                context.router.push(AddDiagnosisRoute(
                                    patientId: widget.id,
                                    complaintId: doctorprovider.invisitId,
                                    visitIndex: widget.visitingIndex));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              child: Text("Add diagnosis",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                            ),
                                          //  SizedBox(width: 8,),
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                                // onPressed: (){
                                          
                                // },
                                onPressed: () async {
                                  await doctorprovider.getallpatientdiagnosis(
                                      widget.id, doctorprovider.invisitId);
                                          
                                  if (doctorprovider
                                      .patientalldiagnosis.isNotEmpty) {
                                        print(doctorprovider
                                                .patientalldiagnosis);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DiagnosisDialog(
                                          id: widget.id,
                                            diagnoses: doctorprovider
                                                .patientalldiagnosis);
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          insetPadding:
                                              const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: EdgeInsets.all(30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "No Diagnosis records found for this visit."),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text("No diagnoses found")),
                                    // );
                                  }
                                },
                                child:
                                Text('View All diagnosis',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),),
                                //  Icon(
                                //   Icons.remove_red_eye_outlined,
                                //   color: Colors.white,
                                // ),
                                ),
                                          //  SizedBox(width: 8,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              // onPressed: (){
                                          
                              // },
                              onPressed: () async {
                                await doctorprovider.getallobservations(
                                    widget.id, doctorprovider.invisitId);
                                          
                                if (doctorprovider
                                    .patientallobservations.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ObservationDialog(
                                          observations: doctorprovider
                                              .patientallobservations);
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        insetPadding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Padding(
                                          padding: EdgeInsets.all(30),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "No Observations records found for this visit."),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text("No diagnoses found")),
                                  // );
                                }
                              },
                              child:
                               Text('View All Observations',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),),
                              //  Icon(
                              //   Icons.ac_unit_outlined,
                              //   color: Colors.white,
                              // ),
                            ),
                          ],
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: FutureBuilder(
                          future: fetchpatientdiagnosis,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.78,
                                  child: _buildShimmerList());
                            } else {
                              return SafeArea(
                                child: doctorprovider.patientdiagnosis.isEmpty
                                    ? SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.78,
                                        child: const Center(
                                          child: Text(
                                            "No Diagnosis to show",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.77,
                                        child: ListView.builder(
                                          itemCount: doctorprovider
                                              .patientdiagnosis.length,
                                          itemBuilder: (context, index) {
                                            final item = doctorprovider
                                                .patientdiagnosis[index];
                                            return DiagnosisModel(
                                              indexnumber: index+1,
                                              patientId: widget.id,
                                              chiefcomplaint:
                                                  item['complaint'] ?? '',
                                              complaintId:
                                                  doctorprovider.invisitId,
                                              createdat: formatDate(
                                                  item['createdAt']),
                                              doneby: item['doneBy']['name'],
                                              diagnosisId: item['id'],
                                              supportingfilesontap: () {
                                                showDialog(
                                      context: context,
                                      builder: (context) {
                                        return InvisitSupportingFilesDialogBox(
                                          patientId: widget.id,
                                          complaintId: doctorprovider.invisitId,
                                          diagnosisId: item['id'],
                                        );
                                      },
                                    );
                                              }, remarkOnTap:() async{
                                            final remark = await doctorprovider.getdoctorinremark(
                                            widget.id, doctorprovider.invisitId, item['id']
                                            );
                                             if (remark != null && remark.isNotEmpty) {
                        showDoctorRemarkDialog(
                          context: context,
                          htmlContent: remark,
                        );
                      } else {
                       showDialog(
                        context: context, builder:(context) {
                         return const Dialog(
                          insetPadding: EdgeInsets.all(16),
                  
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("There is no doctor remarks to show"),
                              ],
                            ),
                          ),
                         );
                       },);
                      }
                                        },
                                            );
                                          },
                                        ),
                                      ),
                              );
                  
                              // return SafeArea(
                              //     child: doctorprovider.gettodaysvisits.isEmpty
                              //         ? SizedBox(
                              //             height:
                              //                 MediaQuery.of(context).size.height *
                              //                     0.65,
                              //             child: const Center(
                              //                 child: Text(
                              //               "No Out Visits to show",
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.bold),
                              //             )))
                              //         : SizedBox(
                              //             height:
                              //                 MediaQuery.of(context).size.height *
                              //                     0.65,
                              //             child: ListView.builder(
                              //               itemCount: doctorprovider
                              //                   .gettodaysvisits.length,
                              //               // Patientpageprovider.allpatients.length,
                              //               itemBuilder: (context, index) {
                              //                 //                                         final sortedPatients = Patientpageprovider.filteredPatients
                              //                 // ..sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
                  
                              //                 // final item = doctorprovider.gettodaysvisits[index];
                  
                              //                 final item = doctorprovider
                              //                     .gettodaysvisits[index];
                              //                 // Patientpageprovider
                              //                 //     .allpatients[index];
                  
                              //                 return TodaysVisitModel(
                              //                   patientname: item['name'],
                              //                   patientId: item['patientId'],
                              //                   viewonTap: () {},
                              //                   startdiagnosisonTap: () {},
                              //                   supportingimagesonTap: () {},
                              //                   chiefcomplaint:
                              //                       item['chief_complaint']??'',
                              //                   diagnosissummary:
                              //                       item['diagnosis_summary'] ?? '',
                              //                   complaintId: item['id'],
                              //                 );
                              //               },
                              //             ),
                              //           ));
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
      fetchpatientdiagnosis =
          doctorprovider.getpatientdiagnosis(widget.id, widget.visitingIndex);
    });
  }
}

// class DiagnosisModel extends StatelessWidget {
//   const DiagnosisModel({
//     super.key,
//     // required this.viewonTap,

//     required this.complaintId,
//     required this.chiefcomplaint,
//     required this.doneby,
//     required this.createdat,
//     required this.patientId,
//     required this.diagnosisId,
//     required this.supportingfilesontap, required this.remarkOnTap,
//   });
//   // final VoidCallback viewonTap;
//   final String complaintId;
//   final String chiefcomplaint;
//   final String doneby;
//   final String createdat;
//   final String patientId;
//   final String diagnosisId;
//   final VoidCallback supportingfilesontap;
//   final VoidCallback remarkOnTap;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 16),
//       child: ListTile(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8))),
//         tileColor: Colors.grey.shade50,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'chiefcomplaint: ',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 Expanded(
//                   child: Text(
//                     chiefcomplaint,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       overflow: TextOverflow.visible,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   'Done by: ',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   doneby,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   'Created at: ',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   createdat,
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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                     onPressed: supportingfilesontap,
//                     icon: const Icon(
//                       Icons.attach_file,
//                       color: Color(0xFF0857C0),
//                     )),
//                 // SizedBox(
//                 //   width: 20,
//                 // ),
//                 DownloadInvisitPdfButton(
//                   patientId: patientId,
//                   complaintId: complaintId,
//                   diagnosisId: diagnosisId,
//                 ),
//                 ElevatedButton(
//                   onPressed: remarkOnTap,
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF0857C0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                        vertical: 14, horizontal: 16),
//                   ),
//                 child:  const Text(
//                   "Remarks",
//                   style: TextStyle(
//                       color: Colors.white,
//           fontWeight: FontWeight.bold,
//                   ),
//                 ))
//               ],
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DiagnosisModel extends StatelessWidget {
  const DiagnosisModel({
    super.key,
    required this.complaintId,
    required this.chiefcomplaint,
    required this.doneby,
    required this.createdat,
    required this.patientId,
    required this.diagnosisId,
    required this.supportingfilesontap,
    required this.remarkOnTap, required this.indexnumber,
  });

  final String complaintId;
  final String chiefcomplaint;
  final String doneby;
  final String createdat;
  final String patientId;
  final String diagnosisId;
  final VoidCallback supportingfilesontap;
  final VoidCallback remarkOnTap;
  final int indexnumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(22))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Diagnosis number badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                   gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Text(
                    "Diagnosis #${indexnumber.toString()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                _label("COMPLAINT"),
                Text(
                  chiefcomplaint,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                _label("DONE BY"),
                Text(
                  doneby,
                  style: const TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 12),
                
                _label("CREATED AT"),
                Text(
                  createdat,
                  style: const TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 20),
                
                /// Bottom buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: supportingfilesontap,
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: ElevatedButton(
                          onPressed: remarkOnTap,
                          style: ElevatedButton.styleFrom(
                            padding:           EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                
                            backgroundColor:  Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Remarks",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                     const SizedBox(width: 12),
                    Expanded(
                      child: DownloadInvisitPdfButton(
                                    patientId: patientId,
                                    complaintId: complaintId,
                                    diagnosisId: diagnosisId,
                                  ),
                    ),
                  ],
                ),
                
               
                
                /// PDF button (same functionality)
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}


class DiagnosisDialog extends StatefulWidget {
  final List<Map<String, dynamic>> diagnoses;
  final String id;

  const DiagnosisDialog({super.key, required this.diagnoses, required this.id});

  @override
  State<DiagnosisDialog> createState() => _DiagnosisDialogState();
}

class _DiagnosisDialogState extends State<DiagnosisDialog> {
  
  // void downloadImage(String url, String filename) async {
  //   try {
  //     log('url: $url');

  //     final bytes = (await get(Uri.parse(url))).bodyBytes;
  //     final dir = await getTemporaryDirectory();

  //     final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

  //     log('filePath: ${file.path}');
  //     //save image to gallery
  //     await GallerySaver.saveImage(file.path, albumName: 'Hospital Management')
  //         .then((success) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.green.shade300,
  //         content: const Text('Image Downloaded to Gallery!'),
  //       ));
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red.shade300,
  //       content: const Text('Something went wrong'),
  //     ));
  //     log('downloadImageE: $e');
  //   }
  // }

  Future<void> downloadImage(BuildContext context, String url, String filename) async {
  try {
    log('url: $url');

    final bytes = (await get(Uri.parse(url))).bodyBytes;
    final dir = await getTemporaryDirectory();

    final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

    log('filePath: ${file.path}');

    // Save image to gallery (with custom album)
    final result = await SaverGallery.saveFile(
      file: file.path,
      name: filename,
      androidRelativePath: 'Pictures/Hospital Management',
      androidExistNotSave: false,
    );

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade300,
        content: const Text('Image Downloaded to Gallery!'),
      ));
    } else {
      throw Exception(result.errorMessage);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade300,
      content: const Text('Something went wrong'),
    ));
    log('downloadImageE: $e');
  }
}

  void shareImage(String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      await Share.shareXFiles([XFile(file.path)], text: filename);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade300,
        content: const Text('Image sharing done successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade300,
        content: const Text('Something Went Wrong (Try again in sometime)!'),
      ));
      print('Something Went Wrong (Try again in sometime)!');
      log('downloadImageE: $e');
    }
  }

  void _viewImage(String imageUrl, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image Viewer'),
            actions: [
              IconButton(
                  onPressed: () => shareImage(imageUrl, filename),
                  icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () => downloadImage(context, imageUrl, filename),
                  icon: const Icon(Icons.download)),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SupportingFilesAi(
              //           patientId: widget.patientId,
              //           complaintId: widget.complaintId,
              //           fileUrl: imageUrl,
              //         ),
              //       ),
              //     );
              //   },
              //   icon:
              //   SvgPicture.asset('assets/images/iconai.svg',
              //   height: 30,
              //   width: 40,
              //   )
              //   //  const Icon(Icons.lightbulb),
              // ),
            ],
          ),
          body: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 100);
              },
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Dialog(
  //     insetPadding: const EdgeInsets.all(16),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Header
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 "Patient Diagnoses",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.close),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),

  //           // Loop through diagnoses
  //           ...widget.diagnoses.asMap().entries.map((entry) {
  //             final index = entry.key;
  //             final d = entry.value;

  //                           final docname = d["doneBy"]?["name"] ?? "Unknown";
  //                           final docuserid = d["doneBy"]?["userid"] ?? "Unknown";
  //                           final role = d['doneByType'];

  //             return Container(
  //               width: double.infinity,
  //               margin: const EdgeInsets.only(bottom: 20),
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey.shade300),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Diagnosis ${index + 1}",
  //                     style: const TextStyle(
  //                         fontSize: 16, fontWeight: FontWeight.w600),
  //                   ),
  //                   const SizedBox(height: 8),

  //                   if (d["complaint"] != null)
  //                     Text("Chief complaint: ${d["complaint"]}"),

  //                   const SizedBox(height: 12),

  //                   // Vitals
  //                   if (d["vitals"] != null &&
  //                       d["vitals"] is List &&
  //                       d["vitals"].isNotEmpty)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Vitals",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         const SizedBox(height: 8),
  //                         Wrap(
  //                           spacing: 8,
  //                           runSpacing: 8,
  //                           children:
  //                               (d["vitals"] as List).map<Widget>((vital) {
  //                             return Card(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Text(vital["name"] ?? "",
  //                                         style: const TextStyle(
  //                                             fontWeight: FontWeight.w600)),
  //                                     Text(vital["value"] ?? ""),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       ],
  //                     ),

  //                   const SizedBox(height: 12),
  //                    Row(
  //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text("Done by: $docname - ",
  //                           style: const TextStyle(fontSize: 14)),
  //                       Text(docuserid,
  //                           style: const TextStyle(
  //                               fontSize: 12, color: Colors.grey)),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 12, ),
  //                    Card(
  //                     color: Colors.green.shade100,
                      
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text("Role: $role",
  //                               style: const TextStyle(fontSize: 14)),
  //                         ),
  //                       ),

  //                       const SizedBox( height: 12,),
  //                   // Diagnosis Summary
  //                   if (d["diagnosis_summary"] != null)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Diagnosis Summary",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         Html(data: d["diagnosis_summary"]),
  //                       ],
  //                     ),

  //                   if (d["diagnosis_summary"] != null)
  //                   const SizedBox(height: 12),

  //                   // Medical Advice
  //                   if (d["medical_advice"] != null)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Medical Advice",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         Html(data: d["medical_advice"]),
  //                       ],
  //                     ),

  //                   if (d["medical_advice"] != null)
  //                   const SizedBox(height: 12),

  //                   // Lab Tests
  //                   if (d["lab_test"] != null)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Lab Tests",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         Html(data: d["lab_test"]),
  //                       ],
  //                     ),

  //                   if (d["lab_test"] != null)
  //                   const SizedBox(height: 12),

  //                   // Doctor's Remark
  //                   if (d["doctors_remark"] != null)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Doctor's Remark",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         Html(data: d["doctors_remark"]),
  //                       ],
  //                     ),


  //                   if (d["doctors_remark"] != null)
  //                   const SizedBox(height: 12),

  //                   // Medication
  //                   if (d["medication"] != null &&
  //                       d["medication"] is List &&
  //                       d["medication"].isNotEmpty)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Medication",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         Column(
  //                           children:
  //                               (d["medication"] as List).map<Widget>((med) {
  //                             return ListTile(
  //                               contentPadding: EdgeInsets.zero,
  //                               title: Text(med["name"] ?? "",
  //                                   style: const TextStyle(
  //                                       fontWeight: FontWeight.w600)),
  //                               subtitle: Text(
  //                                   "${med["type"] ?? ""}, ${med["power"] ?? ""}, ${med["time"]?.join(", ")}"),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       ],
  //                     ),

  //                   if (d["medication"] != null &&
  //                       d["medication"] is List &&
  //                       d["medication"].isNotEmpty)
  //                   const SizedBox(height: 12),

  //                   // Supporting Documents / Images
  //                   if (d["supporting_images"] != null &&
  //                       d["supporting_images"] is List &&
  //                       d["supporting_images"].isNotEmpty)
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text("Supporting Documents",
  //                             style: TextStyle(
  //                                 fontSize: 15, fontWeight: FontWeight.w600)),
  //                         const SizedBox(height: 8),
  //                         Wrap(
  //                           spacing: 8,
  //                           runSpacing: 8,
  //                           children: (d["supporting_images"] as List)
  //                               .map<Widget>((url) {
  //                             final Uri uri = Uri.parse(url.toString());
  //                             bool isPdf =
  //                                 url.toString().toLowerCase().endsWith(".pdf");

  //                             return GestureDetector(
  //                               onTap: () => !isPdf
  //                                   ? _viewImage(url, 'filename')
  //                                   : Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) => PdfViewerPage(
  //                                           url: url,
  //                                           filename: 'fileName',
  //                                         ),
  //                                       ),
  //                                     ),

  //                               // onTap: () async {
  //                               //   if (!await launchUrl(
  //                               //     uri,
  //                               //     mode: LaunchMode.externalApplication,
  //                               //   )) {
  //                               //     throw Exception('Could not launch $uri');
  //                               //   }
  //                               // },
  //                               child: Container(
  //                                 width: 120,
  //                                 height: 100,
  //                                 decoration: BoxDecoration(
  //                                   border:
  //                                       Border.all(color: Colors.grey.shade300),
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 child: isPdf
  //                                     ? const Center(
  //                                         child: Text(
  //                                           "PDF Document",
  //                                           textAlign: TextAlign.center,
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.w600),
  //                                         ),
  //                                       )
  //                                     : ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8),
  //                                         child: Image.network(
  //                                           url,
  //                                           fit: BoxFit.cover,
  //                                           errorBuilder:
  //                                               (context, error, stackTrace) {
  //                                             return const Center(
  //                                                 child: Icon(Icons.image));
  //                                           },
  //                                         ),
  //                                       ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       ],
  //                     ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }


String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }
  @override
Widget build(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.white,
    insetPadding: const EdgeInsets.all(14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [
                const Icon(Icons.assignment, color: AppColors.primary),
                const SizedBox(width: 8),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Diagnosis Records",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text("Patient ID: ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text("${widget.id} ",
                          style:
                              TextStyle(fontSize: 12, color: AppColors.primary,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                  color: AppColors.primary,),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),

            const SizedBox(height: 12),

            /// DIAGNOSIS LIST
            ...widget.diagnoses.asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.blue,
                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          /// DIAGNOSIS HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _pill("Diagnosis #${index + 1}", Colors.blue),
                              Text(formatDate(d["createdAt"]) ?? "",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                    
                          const SizedBox(height: 12),
                    
                          /// COMPLAINT
                          _section("Complaint", Icons.report_problem),
                          Text(d["complaint"] ?? "-"),
                    
                          const SizedBox(height: 12),
                    
                          /// VITALS
                          if (d["vitals"] != null && d["vitals"].isNotEmpty) ...[
                            _section("Vitals", Icons.favorite),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (d["vitals"] as List).map((v) {
                                return _vitalCard(
                                  v["name"] ?? "",
                                  v["value"] ?? "",
                                );
                              }).toList(),
                            ),
                          ],
                    
                          const SizedBox(height: 12),
                    
                          /// DONE BY
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.accent,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${d["doneBy"]?["name"] ?? ""}\n${d["doneBy"]?["userid"] ?? ""}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                _pill(
                                  d["doneByType"] ?? "",
                                  Colors.green,
                                )
                              ],
                            ),
                          ),
                    
                          const SizedBox(height: 12),
                    
                          /// DIAGNOSIS SUMMARY
                          if (d["diagnosis_summary"] != null) ...[
                            _section("Diagnosis Summary", Icons.description),
                            _htmlCard(d["diagnosis_summary"]),
                          ],
                    
                          /// MEDICAL ADVICE
                          if (d["medical_advice"] != null) ...[
                            _section("Medical Advice", Icons.medical_services),
                            _htmlCard(d["medical_advice"]),
                          ],
                    
                          /// LAB TESTS
                          if (d["lab_test"] != null) ...[
                            _section("Lab Tests", Icons.science),
                            _htmlCard(d["lab_test"]),
                          ],
                    
                          /// DOCTOR REMARK
                          if (d["doctors_remark"] != null) ...[
                            _section("Doctor's Remark", Icons.chat),
                            _htmlCard(d["doctors_remark"]),
                          ],
                    
                          /// MEDICATION
                          if (d["medication"] != null &&
                              d["medication"].isNotEmpty) ...[
                            _section("Medication", Icons.medication),
                            ...d["medication"].map<Widget>((med) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.accent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_pharmacy,
                                        color: Colors.red),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(med["name"] ?? "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Dose: ${med["power"]} • ${med["duration"]} days"),
                                          Text(
                                              "When: ${med["time"]?.join(", ")}"),
                                        ],
                                      ),
                                    ),
                                    _pill("Tablet", Colors.red),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                    
                          /// SUPPORTING DOCS
                          const SizedBox(height: 8),
                          _section(
                              "Supporting Documents", Icons.attach_file),
                          const Text("No supporting documents",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ),
  );
}
Widget _section(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6,top: 4),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.red),
        const SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
      ],
    ),
  );
}

Widget _pill(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text,
        style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  );
}

Widget _vitalCard(String name, String value) {
  return Container(
    width: 90,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.accent),
      color: AppColors.badgeBg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Text(name,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.primary,
        fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _htmlCard(String data) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 4),
    // padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.badgeBg,
      border: Border.all(
        color: AppColors.accent
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Html(data: data),
  );
}

}

class ObservationDialog extends StatefulWidget {
  final List<Map<String, dynamic>> observations;

  const ObservationDialog({super.key, required this.observations});

  @override
  State<ObservationDialog> createState() => _ObservationDialogState();
}

class _ObservationDialogState extends State<ObservationDialog> {


// void downloadImage(String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();

//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');
//       //save image to gallery
//       await GallerySaver.saveImage(file.path, albumName: 'Hospital Management')
//           .then((success) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green.shade300,
//           content: const Text('Image Downloaded to Gallery!'),
//         ));
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something went wrong'),
//       ));
//       log('downloadImageE: $e');
//     }
//   }

Future<void> downloadImage(BuildContext context, String url, String filename) async {
  try {
    log('url: $url');

    final bytes = (await get(Uri.parse(url))).bodyBytes;
    final dir = await getTemporaryDirectory();

    final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

    log('filePath: ${file.path}');

    // Save image to gallery (with custom album)
    final result = await SaverGallery.saveFile(
      file: file.path,
      name: filename,
      androidRelativePath: 'Pictures/Hospital Management',
      androidExistNotSave: false,
    );

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade300,
        content: const Text('Image Downloaded to Gallery!'),
      ));
    } else {
      throw Exception(result.errorMessage);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade300,
      content: const Text('Something went wrong'),
    ));
    log('downloadImageE: $e');
  }
}

  void shareImage(String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      await Share.shareXFiles([XFile(file.path)], text: filename);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade300,
        content: const Text('Image sharing done successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade300,
        content: const Text('Something Went Wrong (Try again in sometime)!'),
      ));
      print('Something Went Wrong (Try again in sometime)!');
      log('downloadImageE: $e');
    }
  }

String formatToIST(String dateTime) {
  final utcTime = DateTime.parse(dateTime).toUtc();
  final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
  return DateFormat("dd MMM yyyy, hh:mm a").format(istTime);
}

  void _viewImage(String imageUrl, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image Viewer'),
            actions: [
              IconButton(
                  onPressed: () => shareImage(imageUrl, filename),
                  icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () => downloadImage(context, imageUrl, filename),
                  icon: const Icon(Icons.download)),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SupportingFilesAi(
              //           patientId: widget.patientId,
              //           complaintId: widget.complaintId,
              //           fileUrl: imageUrl,
              //         ),
              //       ),
              //     );
              //   },
              //   icon:
              //   SvgPicture.asset('assets/images/iconai.svg',
              //   height: 30,
              //   width: 40,
              //   )
              //   //  const Icon(Icons.lightbulb),
              // ),
            ],
          ),
          body: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 100);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Patient Observations",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Loop through observations
            ...widget.observations.asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;

              final nurseName = d["doneByNurse"]?["name"] ?? "Unknown";
              // final createdAt = d["createdAt"] != null
              //     ? DateFormat("dd MMM yyyy, hh:mm a")
              //         .format(DateTime.parse(d["createdAt"]))
              //     : "Unknown";

              final createdAt = d["createdAt"] != null
    ? formatToIST(d["createdAt"])
    : "Unknown";

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Observation title
                    Text(
                      "Observation ${index + 1}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    /// Created At + Nurse Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("By Nurse: $nurseName",
                            style: const TextStyle(fontSize: 14)),
                        Text(createdAt,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Vitals
                    if (d["vitals"] != null &&
                        d["vitals"] is List &&
                        d["vitals"].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vitals",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (d["vitals"] as List).map<Widget>((v) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(v["name"] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Text(v["value"] ?? ""),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),

                    /// Summary
                    if (d["summary"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Observation Summary",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            d["summary"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),

                    /// Medicine on time
                    Row(
                      children: [
                        Icon(
                          d["ismedicineOnTime"] == true
                              ? Icons.check_circle
                              : Icons.error,
                          color: d["ismedicineOnTime"] == true
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          d["ismedicineOnTime"] == true
                              ? "Medicines taken on time"
                              : "Medicines not taken on time",
                          style: TextStyle(
                            color: d["ismedicineOnTime"] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12,),

                    if (d["supporting_images"] != null &&
                        d["supporting_images"] is List &&
                        d["supporting_images"].isNotEmpty)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Supporting Documents",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (d["supporting_images"] as List)
                                .map<Widget>((url) {
                              final Uri uri = Uri.parse(url.toString());
                              bool isPdf =
                                  url.toString().toLowerCase().endsWith(".pdf");

                              return GestureDetector(
                                onTap: () => !isPdf
                                    ? _viewImage(url, 'filename')
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerPage(
                                            url: url,
                                            filename: 'fileName',
                                          ),
                                        ),
                                      ),

                                // onTap: () async {
                                //   if (!await launchUrl(
                                //     uri,
                                //     mode: LaunchMode.externalApplication,
                                //   )) {
                                //     throw Exception('Could not launch $uri');
                                //   }
                                // },
                                child: Container(
                                  width: 120,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: isPdf
                                      ? const Center(
                                          child: Text(
                                            "PDF Document",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                  child: Icon(Icons.image));
                                            },
                                          ),
                                        ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}



void showDoctorRemarkDialog({
  required BuildContext context,
  required String htmlContent,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text(
            "Doctor Remark",
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 18),
          ),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
                ],
              ),
            
              Html(
              data: htmlContent,
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  color: Colors.black87,
                ),
              },
            ),
            ],
          ),
        ),
        
      );
    },
  );
}