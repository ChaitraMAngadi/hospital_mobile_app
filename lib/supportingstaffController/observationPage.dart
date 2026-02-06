// import 'dart:developer';
// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:hospital_mobile_app/doctorController/patientInVisit/downloadInvisitPdfButton.dart';
// import 'package:hospital_mobile_app/doctorController/pdfViewPage.dart';
// import 'package:hospital_mobile_app/provider/supportingstaffProvider.dart';
// import 'package:hospital_mobile_app/routes/app_router.dart';
// import 'package:hospital_mobile_app/service/constant.dart';
// import 'package:hospital_mobile_app/service/secure_storage.dart';
// import 'package:hospital_mobile_app/supportingstaffController/viewreportButton.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// // import 'package:gallery_saver_updated/gallery_saver.dart';
// import 'package:saver_gallery/saver_gallery.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';

// @RoutePage()
// class ObservationPage extends StatefulWidget {
//   final String name;
//   final String id;
//   final int visitingIndex;

//   const ObservationPage({
//     super.key,
//     required this.name,
//     required this.id,
//     required this.visitingIndex,
//   });

//   @override
//   State<ObservationPage> createState() => _ObservationPageState();
// }

// class _ObservationPageState extends State<ObservationPage> {
//   late Future fetchpatientobservation;
//   late Future fetchalldiagnosis;
//   late Future fetchallobservations;
//   late String invisitId;

//   final SecureStorage secureStorage = SecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     Supportingstaffprovider supportingstaffprovider =
//         context.read<Supportingstaffprovider>();
//     fetchpatientobservation = supportingstaffprovider.getpatientobservations(
//         widget.id, widget.visitingIndex);
//     invisitId = supportingstaffprovider.invisitId;

//     fetchalldiagnosis = supportingstaffprovider.getallpatientdiagnosis(
//         widget.id, supportingstaffprovider.invisitId);
//     fetchallobservations = supportingstaffprovider.getallobservations(
//         widget.id, supportingstaffprovider.invisitId);
//   }

//   String formatDate(String date) {
//     final parsedDate = DateTime.parse(date);
//     final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
//     return formattedDate;
//   }

//   // Keep your existing shimmer methods
//   Widget _buildShimmerItem() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white54,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildShimmerBox(width: 200, height: 32, borderRadius: 16),
//               _buildShimmerBox(width: 60, height: 32, borderRadius: 16),
//             ],
//           ),
//           SizedBox(height: 12),
//           _buildShimmerBox(width: double.infinity, height: 18),
//           SizedBox(height: 8),
//           _buildShimmerBox(width: 200, height: 16),
//           SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
//               _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
//               _buildShimmerBox(width: 90, height: 32, borderRadius: 16),
//             ],
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmerBox(
//       {required double width,
//       required double height,
//       double borderRadius = 8}) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(borderRadius),
//         gradient: LinearGradient(
//           begin: Alignment(-1.0, 0.0),
//           end: Alignment(1.0, 0.0),
//           colors: [
//             Colors.grey[300]!,
//             Colors.grey[100]!,
//             Colors.grey[300]!,
//           ],
//           stops: [0.0, 0.5, 1.0],
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerList() {
//     return ListView.builder(
//       itemCount: 6,
//       itemBuilder: (context, index) {
//         return AnimatedContainer(
//           duration: Duration(milliseconds: 1000 + (index * 100)),
//           child: _buildShimmerItem(),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             '${widget.name} - ${widget.id}',
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         body: RefreshIndicator(
//           onRefresh: _handleRefresh,
//           child: Consumer<Supportingstaffprovider>(
//             builder: (context, supportingstaffprovider, child) {
//               return SafeArea(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             context.router.push(AddObservationRoute(
//                               patientId: widget.id,
//                               complaintId: supportingstaffprovider.invisitId,
//                               visitIndex: widget.visitingIndex,
//                             ));
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 10),
//                           ),
//                           child: Text("Add Observation",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               )),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 10),
//                               ),
//                               // onPressed: (){

//                               // },
//                               onPressed: () async {
//                                 await supportingstaffprovider
//                                     .getallpatientdiagnosis(widget.id,
//                                         supportingstaffprovider.invisitId);

//                                 if (supportingstaffprovider
//                                     .patientalldiagnosis.isNotEmpty) {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return DiagnosisDialog(
//                                           diagnoses: supportingstaffprovider
//                                               .patientalldiagnosis);
//                                     },
//                                   );
//                                 } else {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return Dialog(
//                                         insetPadding: const EdgeInsets.all(16),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(16)),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(30),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                   "No Diagnosis records found for this visit."),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Text(
//                                 'View All diagnosis',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
// //  SizedBox(width: 8,),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.brown,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 10),
//                               ),
//                               // onPressed: (){

//                               // },
//                               onPressed: () async {
//                                 await supportingstaffprovider
//                                     .getallobservations(widget.id,
//                                         supportingstaffprovider.invisitId);

//                                 if (supportingstaffprovider
//                                     .patientallobservations.isNotEmpty) {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return ObservationDialog(
//                                           observations: supportingstaffprovider
//                                               .patientallobservations);
//                                     },
//                                   );
//                                 } else {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return Dialog(
//                                         insetPadding: const EdgeInsets.all(16),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(16)),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(30),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                   "No Observations records found for this visit."),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Text(
//                                 'View All Observations',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               //  Icon(
//                               //   Icons.ac_unit_outlined,
//                               //   color: Colors.white,
//                               // ),
//                             ),
//                           ],
//                         ),
//                         RefreshIndicator(
//                           onRefresh: _handleRefresh,
//                           child: FutureBuilder(
//                             future: fetchpatientobservation,
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return SizedBox(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.8,
//                                     child: _buildShimmerList());
//                               } else {
//                                 return SafeArea(
//                                   child: supportingstaffprovider
//                                           .patientobservations.isEmpty
//                                       ? SizedBox(
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                               0.8,
//                                           child: const Center(
//                                             child: Text(
//                                               "No Observation to show",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         )
//                                       : SizedBox(
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                               0.8,
//                                           child: ListView.builder(
//                                             itemCount: supportingstaffprovider
//                                                 .patientobservations.length,
//                                             itemBuilder: (context, index) {
//                                               final item =
//                                                   supportingstaffprovider
//                                                           .patientobservations[
//                                                       index];
//                                               return DiagnosisModel(
//                                                 patientId: widget.id,
//                                                 chiefcomplaint:
//                                                     item['complaint'] ?? '',
//                                                 complaintId:
//                                                     supportingstaffprovider
//                                                         .invisitId,
//                                                 createdat: formatDate(
//                                                     item['createdAt']),
//                                                 doneby: item['doneBy']['name'],
//                                                 diagnosisId: item['id'],
//                                                 //           supportingfilesontap: () {
//                                                 //             showDialog(
//                                                 //   context: context,
//                                                 //   builder: (context) {
//                                                 //     return InvisitSupportingFilesDialogBox(
//                                                 //       patientId: widget.id,
//                                                 //       complaintId: doctorprovider.invisitId,
//                                                 //       diagnosisId: item['id'],
//                                                 //     );
//                                                 //   },
//                                                 // );
//                                                 //           },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                 );

//                                 // return SafeArea(
//                                 //     child: doctorprovider.gettodaysvisits.isEmpty
//                                 //         ? SizedBox(
//                                 //             height:
//                                 //                 MediaQuery.of(context).size.height *
//                                 //                     0.65,
//                                 //             child: const Center(
//                                 //                 child: Text(
//                                 //               "No Out Visits to show",
//                                 //               style: TextStyle(
//                                 //                   fontWeight: FontWeight.bold),
//                                 //             )))
//                                 //         : SizedBox(
//                                 //             height:
//                                 //                 MediaQuery.of(context).size.height *
//                                 //                     0.65,
//                                 //             child: ListView.builder(
//                                 //               itemCount: doctorprovider
//                                 //                   .gettodaysvisits.length,
//                                 //               // Patientpageprovider.allpatients.length,
//                                 //               itemBuilder: (context, index) {
//                                 //                 //                                         final sortedPatients = Patientpageprovider.filteredPatients
//                                 //                 // ..sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

//                                 //                 // final item = doctorprovider.gettodaysvisits[index];

//                                 //                 final item = doctorprovider
//                                 //                     .gettodaysvisits[index];
//                                 //                 // Patientpageprovider
//                                 //                 //     .allpatients[index];

//                                 //                 return TodaysVisitModel(
//                                 //                   patientname: item['name'],
//                                 //                   patientId: item['patientId'],
//                                 //                   viewonTap: () {},
//                                 //                   startdiagnosisonTap: () {},
//                                 //                   supportingimagesonTap: () {},
//                                 //                   chiefcomplaint:
//                                 //                       item['chief_complaint']??'',
//                                 //                   diagnosissummary:
//                                 //                       item['diagnosis_summary'] ?? '',
//                                 //                   complaintId: item['id'],
//                                 //                 );
//                                 //               },
//                                 //             ),
//                                 //           ));
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ));
//   }

//   Future<void> _handleRefresh() async {
//     Supportingstaffprovider supportingstaffprovider =
//         context.read<Supportingstaffprovider>();

//     await Future.delayed(Duration(seconds: 2));
//     Constants.nursetoken =
//         await secureStorage.readSecureData('nursetoken') ?? '';
//     setState(() {
//       fetchpatientobservation = supportingstaffprovider.getpatientobservations(
//           widget.id, widget.visitingIndex);
//     });
//   }
// }

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
//     // required this.supportingfilesontap,
//   });
//   // final VoidCallback viewonTap;
//   final String complaintId;
//   final String chiefcomplaint;
//   final String doneby;
//   final String createdat;
//   final String patientId;
//   final String diagnosisId;
//   // final VoidCallback supportingfilesontap;

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
//               children: [
//                 // IconButton(
//                 //     onPressed: supportingfilesontap,
//                 //     icon: const Icon(
//                 //       Icons.attach_file,
//                 //       color: Color(0xFF0857C0),
//                 //     )),
//                 // SizedBox(
//                 //   width: 20,
//                 // ),
//                 ViewreportInvisitPdfButton(
//                   patientId: patientId,
//                   complaintId: complaintId,
//                   diagnosisId: diagnosisId,
//                 ),
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

// class DiagnosisDialog extends StatefulWidget {
//   final List<Map<String, dynamic>> diagnoses;

//   const DiagnosisDialog({super.key, required this.diagnoses});

//   @override
//   State<DiagnosisDialog> createState() => _DiagnosisDialogState();
// }

// class _DiagnosisDialogState extends State<DiagnosisDialog> {
//   // void downloadImage(String url, String filename) async {
//   //   try {
//   //     log('url: $url');

//   //     final bytes = (await get(Uri.parse(url))).bodyBytes;
//   //     final dir = await getTemporaryDirectory();

//   //     final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//   //     log('filePath: ${file.path}');
//   //     //save image to gallery
//   //     await GallerySaver.saveImage(file.path, albumName: 'Hospital Management')
//   //         .then((success) {
//   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         backgroundColor: Colors.green.shade300,
//   //         content: const Text('Image Downloaded to Gallery!'),
//   //       ));
//   //     });
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //       backgroundColor: Colors.red.shade300,
//   //       content: const Text('Something went wrong'),
//   //     ));
//   //     log('downloadImageE: $e');
//   //   }
//   // }

//   Future<void> downloadImage(BuildContext context, String url, String filename) async {
//   try {
//     log('url: $url');

//     final bytes = (await get(Uri.parse(url))).bodyBytes;
//     final dir = await getTemporaryDirectory();

//     final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//     log('filePath: ${file.path}');

//     // Save image to gallery (with custom album)
//     final result = await SaverGallery.saveFile(
//       file: file.path,
//       name: filename,
//       androidRelativePath: 'Pictures/Hospital Management',
//       androidExistNotSave: false,
//     );

//     if (result.isSuccess) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image Downloaded to Gallery!'),
//       ));
//     } else {
//       throw Exception(result.errorMessage);
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: Colors.red.shade300,
//       content: const Text('Something went wrong'),
//     ));
//     log('downloadImageE: $e');
//   }
// }

//   void shareImage(String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();
//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       await Share.shareXFiles([XFile(file.path)], text: filename);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image sharing done successfully'),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something Went Wrong (Try again in sometime)!'),
//       ));
//       print('Something Went Wrong (Try again in sometime)!');
//       log('downloadImageE: $e');
//     }
//   }

//   void _viewImage(String imageUrl, String filename) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Image Viewer'),
//             actions: [
//               IconButton(
//                   onPressed: () => shareImage(imageUrl, filename),
//                   icon: const Icon(Icons.share)),
//               IconButton(
//                   onPressed: () => downloadImage(context, imageUrl, filename),
//                   icon: const Icon(Icons.download)),
//               // IconButton(
//               //   onPressed: () {
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => SupportingFilesAi(
//               //           patientId: widget.patientId,
//               //           complaintId: widget.complaintId,
//               //           fileUrl: imageUrl,
//               //         ),
//               //       ),
//               //     );
//               //   },
//               //   icon:
//               //   SvgPicture.asset('assets/images/iconai.svg',
//               //   height: 30,
//               //   width: 40,
//               //   )
//               //   //  const Icon(Icons.lightbulb),
//               // ),
//             ],
//           ),
//           body: Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.broken_image, size: 100);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Diagnoses",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // Loop through diagnoses
//             ...widget.diagnoses.asMap().entries.map((entry) {
//               final index = entry.key;
//               final d = entry.value;

//               return Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Diagnosis ${index + 1}",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),

//                     if (d["complaint"] != null)
//                       Text("Chief complaint: ${d["complaint"]}"),

//                     const SizedBox(height: 12),

//                     // Vitals
//                     if (d["vitals"] != null &&
//                         d["vitals"] is List &&
//                         d["vitals"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Vitals",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children:
//                                 (d["vitals"] as List).map<Widget>((vital) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(vital["name"] ?? "",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.w600)),
//                                       Text(vital["value"] ?? ""),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Diagnosis Summary
//                     if (d["diagnosis_summary"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Diagnosis Summary",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["diagnosis_summary"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Medical Advice
//                     if (d["medical_advice"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Medical Advice",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["medical_advice"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Lab Tests
//                     if (d["lab_test"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Lab Tests",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["lab_test"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Doctor's Remark
//                     if (d["doctors_remark"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Doctor's Remark",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["doctors_remark"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Medication
//                     if (d["medication"] != null &&
//                         d["medication"] is List &&
//                         d["medication"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Medication",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Column(
//                             children:
//                                 (d["medication"] as List).map<Widget>((med) {
//                               return ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text(med["name"] ?? "",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w600)),
//                                 subtitle: Text(
//                                     "${med["type"] ?? ""}, ${med["power"] ?? ""}, ${med["time"]?.join(", ")}"),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     // Supporting Documents / Images
//                     if (d["supporting_images"] != null &&
//                         d["supporting_images"] is List &&
//                         d["supporting_images"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Supporting Documents",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["supporting_images"] as List)
//                                 .map<Widget>((url) {
//                               // final Uri uri = Uri.parse(url.toString());
//                               bool isPdf =
//                                   url.toString().toLowerCase().endsWith(".pdf");

//                               return GestureDetector(
//                                 onTap: () => !isPdf
//                                     ? _viewImage(url, 'filename')
//                                     : Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PdfViewerPage(
//                                             url: url,
//                                             filename: 'fileName',
//                                           ),
//                                         ),
//                                       ),

//                                 // onTap: () async {
//                                 //   if (!await launchUrl(
//                                 //     uri,
//                                 //     mode: LaunchMode.externalApplication,
//                                 //   )) {
//                                 //     throw Exception('Could not launch $uri');
//                                 //   }
//                                 // },
//                                 child: Container(
//                                   width: 120,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.grey.shade300),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: isPdf
//                                       ? const Center(
//                                           child: Text(
//                                             "PDF Document",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       : ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             url,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return const Center(
//                                                   child: Icon(Icons.image));
//                                             },
//                                           ),
//                                         ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ObservationDialog extends StatefulWidget {
//   final List<Map<String, dynamic>> observations;

//   const ObservationDialog({super.key, required this.observations});

//   @override
//   State<ObservationDialog> createState() => _ObservationDialogState();
// }

// class _ObservationDialogState extends State<ObservationDialog> {
//   // void downloadImage(String url, String filename) async {
//   //   try {
//   //     log('url: $url');

//   //     final bytes = (await get(Uri.parse(url))).bodyBytes;
//   //     final dir = await getTemporaryDirectory();

//   //     final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//   //     log('filePath: ${file.path}');
//   //     //save image to gallery
//   //     await GallerySaver.saveImage(file.path, albumName: 'Hospital Management')
//   //         .then((success) {
//   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         backgroundColor: Colors.green.shade300,
//   //         content: const Text('Image Downloaded to Gallery!'),
//   //       ));
//   //     });
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //       backgroundColor: Colors.red.shade300,
//   //       content: const Text('Something went wrong'),
//   //     ));
//   //     log('downloadImageE: $e');
//   //   }
//   // }


// Future<void> downloadImage(BuildContext context, String url, String filename) async {
//   try {
//     log('url: $url');

//     final bytes = (await get(Uri.parse(url))).bodyBytes;
//     final dir = await getTemporaryDirectory();

//     final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//     log('filePath: ${file.path}');

//     // Save image to gallery (with custom album)
//     final result = await SaverGallery.saveFile(
//       file: file.path,
//       name: filename,
//       androidRelativePath: 'Pictures/Hospital Management',
//       androidExistNotSave: false,
//     );

//     if (result.isSuccess) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image Downloaded to Gallery!'),
//       ));
//     } else {
//       throw Exception(result.errorMessage);
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: Colors.red.shade300,
//       content: const Text('Something went wrong'),
//     ));
//     log('downloadImageE: $e');
//   }
// }


//   void shareImage(String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();
//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       await Share.shareXFiles([XFile(file.path)], text: filename);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image sharing done successfully'),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something Went Wrong (Try again in sometime)!'),
//       ));
//       print('Something Went Wrong (Try again in sometime)!');
//       log('downloadImageE: $e');
//     }
//   }

//   String formatToIST(String dateTime) {
//   final utcTime = DateTime.parse(dateTime).toUtc();
//   final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
//   return DateFormat("dd MMM yyyy, hh:mm a").format(istTime);
// }

//   void _viewImage(String imageUrl, String filename) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Image Viewer'),
//             actions: [
//               IconButton(
//                   onPressed: () => shareImage(imageUrl, filename),
//                   icon: const Icon(Icons.share)),
//               IconButton(
//                   onPressed: () => downloadImage(context, imageUrl, filename),
//                   icon: const Icon(Icons.download)),
//               // IconButton(
//               //   onPressed: () {
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => SupportingFilesAi(
//               //           patientId: widget.patientId,
//               //           complaintId: widget.complaintId,
//               //           fileUrl: imageUrl,
//               //         ),
//               //       ),
//               //     );
//               //   },
//               //   icon:
//               //   SvgPicture.asset('assets/images/iconai.svg',
//               //   height: 30,
//               //   width: 40,
//               //   )
//               //   //  const Icon(Icons.lightbulb),
//               // ),
//             ],
//           ),
//           body: Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.broken_image, size: 100);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Observations",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             /// Loop through observations
//             ...widget.observations.asMap().entries.map((entry) {
//               final index = entry.key;
//               final d = entry.value;

//               final nurseName = d["doneByNurse"]?["name"] ?? "Unknown";
//               // final createdAt = d["createdAt"] != null
//               //     ? DateFormat("dd MMM yyyy, hh:mm a")
//               //         .format(DateTime.parse(d["createdAt"]))
//               //     : "Unknown";

//               final createdAt = d["createdAt"] != null
//     ? formatToIST(d["createdAt"])
//     : "Unknown";

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 20),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Observation title
//                     Text(
//                       "Observation ${index + 1}",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),

//                     /// Created At + Nurse Info
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("By Nurse: $nurseName",
//                             style: const TextStyle(fontSize: 14)),
//                         Text(createdAt,
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.grey)),
//                       ],
//                     ),
//                     const SizedBox(height: 12),

//                     /// Vitals
//                     if (d["vitals"] != null &&
//                         d["vitals"] is List &&
//                         d["vitals"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Vitals",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["vitals"] as List).map<Widget>((v) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(v["name"] ?? "",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.w600)),
//                                       Text(v["value"] ?? ""),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     /// Summary
//                     if (d["summary"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Observation Summary",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 6),
//                           Text(
//                             d["summary"],
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     /// Medicine on time
//                     Row(
//                       children: [
//                         Icon(
//                           d["ismedicineOnTime"] == true
//                               ? Icons.check_circle
//                               : Icons.error,
//                           color: d["ismedicineOnTime"] == true
//                               ? Colors.green
//                               : Colors.red,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           d["ismedicineOnTime"] == true
//                               ? "Medicines taken on time"
//                               : "Medicines not taken on time",
//                           style: TextStyle(
//                             color: d["ismedicineOnTime"] == true
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(
//                       height: 12,
//                     ),

//                     if (d["supporting_images"] != null &&
//                         d["supporting_images"] is List &&
//                         d["supporting_images"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Supporting Documents",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["supporting_images"] as List)
//                                 .map<Widget>((url) {
//                               // final Uri uri = Uri.parse(url.toString());
//                               bool isPdf =
//                                   url.toString().toLowerCase().endsWith(".pdf");

//                               return GestureDetector(
//                                 onTap: () => !isPdf
//                                     ? _viewImage(url, 'filename')
//                                     : Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PdfViewerPage(
//                                             url: url,
//                                             filename: 'fileName',
//                                           ),
//                                         ),
//                                       ),

//                                 // onTap: () async {
//                                 //   if (!await launchUrl(
//                                 //     uri,
//                                 //     mode: LaunchMode.externalApplication,
//                                 //   )) {
//                                 //     throw Exception('Could not launch $uri');
//                                 //   }
//                                 // },
//                                 child: Container(
//                                   width: 120,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.grey.shade300),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: isPdf
//                                       ? const Center(
//                                           child: Text(
//                                             "PDF Document",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       : ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             url,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return const Center(
//                                                   child: Icon(Icons.image));
//                                             },
//                                           ),
//                                         ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/downloadInvisitPdfButton.dart';
import 'package:hospital_mobile_app/doctorController/pdfViewPage.dart';
import 'package:hospital_mobile_app/provider/supportingstaffProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/supportingstaffController/viewreportButton.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
// Import your AppColors file here
// import 'path_to_your/app_colors.dart';

@RoutePage()
class ObservationPage extends StatefulWidget {
  final String name;
  final String id;
  final int visitingIndex;

  const ObservationPage({
    super.key,
    required this.name,
    required this.id,
    required this.visitingIndex,
  });

  @override
  State<ObservationPage> createState() => _ObservationPageState();
}

class _ObservationPageState extends State<ObservationPage> {
  late Future fetchpatientobservation;
  late Future fetchalldiagnosis;
  late Future fetchallobservations;
  late String invisitId;

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    Supportingstaffprovider supportingstaffprovider =
        context.read<Supportingstaffprovider>();
    fetchpatientobservation = supportingstaffprovider.getpatientobservations(
        widget.id, widget.visitingIndex);
    invisitId = supportingstaffprovider.invisitId;

    fetchalldiagnosis = supportingstaffprovider.getallpatientdiagnosis(
        widget.id, supportingstaffprovider.invisitId);
    fetchallobservations = supportingstaffprovider.getallobservations(
        widget.id, supportingstaffprovider.invisitId);
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
    return Scaffold(
        appBar: AppBar(
             flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
          title: Text(
            '${widget.name} - ${widget.id}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,
          color: Colors.white,)),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Consumer<Supportingstaffprovider>(
            builder: (context, supportingstaffprovider, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Add Observation Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: [
                              Colors.green,Colors.green.shade300
                            ])
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.router.push(AddObservationRoute(
                                patientId: widget.id,
                                complaintId: supportingstaffprovider.invisitId,
                                visitIndex: widget.visitingIndex,
                              ));
                            },
                            icon: Icon(Icons.add_circle_outline, color: Colors.white),
                            label: Text(
                              "Add Observation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // View All Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: AppColors.secondaryGradient,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await supportingstaffprovider
                                        .getallpatientdiagnosis(widget.id,
                                            supportingstaffprovider.invisitId);
                                
                                    if (supportingstaffprovider
                                        .patientalldiagnosis.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DiagnosisDialog(
                                              diagnoses: supportingstaffprovider
                                                  .patientalldiagnosis);
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
                                                      "No Diagnosis records found for this visit."),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.folder_outlined, color: Colors.white, size: 20),
                                  label: Text(
                                    'View All Diagnosis',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await supportingstaffprovider
                                        .getallobservations(widget.id,
                                            supportingstaffprovider.invisitId);
                                
                                    if (supportingstaffprovider
                                        .patientallobservations.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ObservationDialog(
                                              observations: supportingstaffprovider
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
                                    }
                                  },
                                  icon: Icon(Icons.visibility_outlined, color: Colors.white, size: 20),
                                  label: Text(
                                    'View All Observation',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Observation List
                        RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: FutureBuilder(
                            future: fetchpatientobservation,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: _buildShimmerList());
                              } else {
                                return SafeArea(
                                  child: supportingstaffprovider
                                          .patientobservations.isEmpty
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          child: const Center(
                                            child: Text(
                                              "No Observation to show",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          child: ListView.builder(
                                            itemCount: supportingstaffprovider
                                                .patientobservations.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  supportingstaffprovider
                                                          .patientobservations[
                                                      index];
                                              return DiagnosisModel(
                                                patientId: widget.id,
                                                chiefcomplaint:
                                                    item['complaint'] ?? '',
                                                complaintId:
                                                    supportingstaffprovider
                                                        .invisitId,
                                                createdat: formatDate(
                                                    item['createdAt']),
                                                doneby: item['doneBy']['name'],
                                                diagnosisId: item['id'],
                                                observationNumber: index + 1,
                                                doneById: item['doneBy']['userid'] ?? '',
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
                ),
              );
            },
          ),
        ));
  }

  Future<void> _handleRefresh() async {
    Supportingstaffprovider supportingstaffprovider =
        context.read<Supportingstaffprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.nursetoken =
        await secureStorage.readSecureData('nursetoken') ?? '';
    setState(() {
      fetchpatientobservation = supportingstaffprovider.getpatientobservations(
          widget.id, widget.visitingIndex);
    });
  }
}

class DiagnosisModel extends StatelessWidget {
  const DiagnosisModel({
    super.key,
    required this.complaintId,
    required this.chiefcomplaint,
    required this.doneby,
    required this.createdat,
    required this.patientId,
    required this.diagnosisId,
    required this.observationNumber,
    required this.doneById,
  });

  final String complaintId;
  final String chiefcomplaint;
  final String doneby;
  final String createdat;
  final String patientId;
  final String diagnosisId;
  final int observationNumber;
  final String doneById;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 2, vertical: 8) ,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12),bottom: Radius.circular(22)),
        
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top:Radius.circular(22)),
              gradient: AppColors.primaryGradient,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Observation Number Badge
                Text(
                  "OBSERVATION",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                   gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "#$observationNumber",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Done By Section
                Text(
                  "DONE BY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  doneby,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "ID: $doneById",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 10),
                
                // Created At Section
                Text(
                  "CREATED AT",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                   
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  createdat,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                
                // View Report Button
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       // Your view report logic
                //     },
                //     icon: Icon(Icons.description_outlined, color: Colors.white, size: 20),
                //     label: Text(
                //       "View Report",
                //       style: TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.primary,
                //       padding: EdgeInsets.symmetric(vertical: 12),
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ),
                // ),
                 ViewreportInvisitPdfButton(
                        patientId: patientId,
                        complaintId: complaintId,
                        diagnosisId: diagnosisId,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Keep your existing DiagnosisDialog and ObservationDialog classes as they are
class DiagnosisDialog extends StatefulWidget {
  final List<Map<String, dynamic>> diagnoses;

  const DiagnosisDialog({super.key, required this.diagnoses});

  @override
  State<DiagnosisDialog> createState() => _DiagnosisDialogState();
}

// class _DiagnosisDialogState extends State<DiagnosisDialog> {
//   Future<void> downloadImage(BuildContext context, String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();

//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       final result = await SaverGallery.saveFile(
//         file: file.path,
//         name: filename,
//         androidRelativePath: 'Pictures/Hospital Management',
//         androidExistNotSave: false,
//       );

//       if (result.isSuccess) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green.shade300,
//           content: const Text('Image Downloaded to Gallery!'),
//         ));
//       } else {
//         throw Exception(result.errorMessage);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something went wrong'),
//       ));
//       log('downloadImageE: $e');
//     }
//   }

//   void shareImage(String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();
//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       await Share.shareXFiles([XFile(file.path)], text: filename);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image sharing done successfully'),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something Went Wrong (Try again in sometime)!'),
//       ));
//       print('Something Went Wrong (Try again in sometime)!');
//       log('downloadImageE: $e');
//     }
//   }

//   void _viewImage(String imageUrl, String filename) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Image Viewer'),
//             actions: [
//               IconButton(
//                   onPressed: () => shareImage(imageUrl, filename),
//                   icon: const Icon(Icons.share)),
//               IconButton(
//                   onPressed: () => downloadImage(context, imageUrl, filename),
//                   icon: const Icon(Icons.download)),
//             ],
//           ),
//           body: Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.broken_image, size: 100);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Diagnoses",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             ...widget.diagnoses.asMap().entries.map((entry) {
//               final index = entry.key;
//               final d = entry.value;

//               return Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Diagnosis ${index + 1}",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),

//                     if (d["complaint"] != null)
//                       Text("Chief complaint: ${d["complaint"]}"),

//                     const SizedBox(height: 12),

//                     if (d["vitals"] != null &&
//                         d["vitals"] is List &&
//                         d["vitals"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Vitals",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children:
//                                 (d["vitals"] as List).map<Widget>((vital) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(vital["name"] ?? "",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.w600)),
//                                       Text(vital["value"] ?? ""),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["diagnosis_summary"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Diagnosis Summary",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["diagnosis_summary"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["medical_advice"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Medical Advice",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["medical_advice"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["lab_test"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Lab Tests",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["lab_test"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["doctors_remark"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Doctor's Remark",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Html(data: d["doctors_remark"]),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["medication"] != null &&
//                         d["medication"] is List &&
//                         d["medication"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Medication",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           Column(
//                             children:
//                                 (d["medication"] as List).map<Widget>((med) {
//                               return ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text(med["name"] ?? "",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w600)),
//                                 subtitle: Text(
//                                     "${med["type"] ?? ""}, ${med["power"] ?? ""}, ${med["time"]?.join(", ")}"),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["supporting_images"] != null &&
//                         d["supporting_images"] is List &&
//                         d["supporting_images"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Supporting Documents",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["supporting_images"] as List)
//                                 .map<Widget>((url) {
//                               bool isPdf =
//                                   url.toString().toLowerCase().endsWith(".pdf");

//                               return GestureDetector(
//                                 onTap: () => !isPdf
//                                     ? _viewImage(url, 'filename')
//                                     : Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PdfViewerPage(
//                                             url: url,
//                                             filename: 'fileName',
//                                           ),
//                                         ),
//                                       ),
//                                 child: Container(
//                                   width: 120,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.grey.shade300),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: isPdf
//                                       ? const Center(
//                                           child: Text(
//                                             "PDF Document",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       : ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             url,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return const Center(
//                                                   child: Icon(Icons.image));
//                                             },
//                                           ),
//                                         ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _DiagnosisDialogState extends State<DiagnosisDialog> {
  Future<void> downloadImage(BuildContext context, String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();

      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Patient Diagnoses",
                  style: TextStyle(fontSize: 20,
                  color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                  color: AppColors.primary,),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Reversed to show latest diagnosis first
            ...widget.diagnoses.reversed.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Diagnosis badge and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Diagnosis #${widget.diagnoses.length - index}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (d["created_at"] != null)
                          Text(
                            d["created_at"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Complaint
                    if (d["complaint"] != null)
                      Text(
                        d["complaint"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Vitals Section
                    if (d["vitals"] != null &&
                        d["vitals"] is List &&
                        d["vitals"].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.favorite,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Vitals",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: (d["vitals"] as List).map<Widget>((vital) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeBg,
                                  border: Border.all(color: AppColors.accent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      vital["name"] ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      vital["value"] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Done By Section
                    if (d["doctor_name"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Done By",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                d["doctor_name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (d["status"] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    d["status"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (d["doctor_specialty"] != null)
                            Text(
                              d["doctor_specialty"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Diagnosis Summary
                    if (d["diagnosis_summary"] != "")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Diagnosis Summary",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                           padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.badgeBg,
                            border: Border.all(
                              color: AppColors.accent
                            )  

                            ),
                            child: Html(
                              data: d["diagnosis_summary"],
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Medical Advice
                    if (d["medical_advice"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_hospital,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Medical Advice",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                             padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBg,
                              borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent
                            )  

                            ),
                            child: Html(
                              data: d["medical_advice"],
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Lab Tests
                    if (d["lab_test"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.science,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Lab Tests",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            
                              //  padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBg,
                              borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent
                            )  

                            ),
                            child: Html(
                              data: d["lab_test"],
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Doctor's Remark
                    if (d["doctors_remark"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.comment,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Doctor's Remark",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                               padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBg,
                              borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent
                            )  

                            ),
                            child: Html(
                              data: d["doctors_remark"],
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Medication Section
                    if (d["medication"] != null &&
                        d["medication"] is List &&
                        d["medication"].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medication,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Medication",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...(d["medication"] as List).map<Widget>((med) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          med["name"] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (med["time"] != null &&
                                          med["time"] is List)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade400,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            (med["time"] as List).join(", "),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (med["type"] != null)
                                        Text(
                                          med["type"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      if (med["power"] != null) ...[
                                        Text(
                                          " • ",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                        Text(
                                          med["power"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (med["special_instructions"] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Special Instructions: ${med["special_instructions"]}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Supporting Documents
                    if (d["supporting_images"] != null &&
                        d["supporting_images"] is List &&
                        d["supporting_images"].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.attach_file,
                                  color: Colors.red.shade400, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Supporting Documents",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          (d["supporting_images"] as List).isEmpty
                              ? Text(
                                  "No supporting documents",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (d["supporting_images"] as List)
                                      .map<Widget>((url) {
                                    bool isPdf = url
                                        .toString()
                                        .toLowerCase()
                                        .endsWith(".pdf");

                                    return GestureDetector(
                                      onTap: () => !isPdf
                                          ? _viewImage(url, 'filename')
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfViewerPage(
                                                  url: url,
                                                  filename: 'fileName',
                                                ),
                                              ),
                                            ),
                                      child: Container(
                                        width: 120,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: isPdf
                                            ? const Center(
                                                child: Text(
                                                  "PDF Document",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                        child:
                                                            Icon(Icons.image));
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
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ObservationDialog extends StatefulWidget {
  final List<Map<String, dynamic>> observations;

  const ObservationDialog({super.key, required this.observations});

  @override
  State<ObservationDialog> createState() => _ObservationDialogState();
}

// class _ObservationDialogState extends State<ObservationDialog> {
//   Future<void> downloadImage(BuildContext context, String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();

//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       final result = await SaverGallery.saveFile(
//         file: file.path,
//         name: filename,
//         androidRelativePath: 'Pictures/Hospital Management',
//         androidExistNotSave: false,
//       );

//       if (result.isSuccess) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green.shade300,
//           content: const Text('Image Downloaded to Gallery!'),
//         ));
//       } else {
//         throw Exception(result.errorMessage);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something went wrong'),
//       ));
//       log('downloadImageE: $e');
//     }
//   }

//   void shareImage(String url, String filename) async {
//     try {
//       log('url: $url');

//       final bytes = (await get(Uri.parse(url))).bodyBytes;
//       final dir = await getTemporaryDirectory();
//       final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

//       log('filePath: ${file.path}');

//       await Share.shareXFiles([XFile(file.path)], text: filename);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.green.shade300,
//         content: const Text('Image sharing done successfully'),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.red.shade300,
//         content: const Text('Something Went Wrong (Try again in sometime)!'),
//       ));
//       print('Something Went Wrong (Try again in sometime)!');
//       log('downloadImageE: $e');
//     }
//   }

//   String formatToIST(String dateTime) {
//     final utcTime = DateTime.parse(dateTime).toUtc();
//     final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
//     return DateFormat("dd MMM yyyy, hh:mm a").format(istTime);
//   }

//   void _viewImage(String imageUrl, String filename) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Image Viewer'),
//             actions: [
//               IconButton(
//                   onPressed: () => shareImage(imageUrl, filename),
//                   icon: const Icon(Icons.share)),
//               IconButton(
//                   onPressed: () => downloadImage(context, imageUrl, filename),
//                   icon: const Icon(Icons.download)),
//             ],
//           ),
//           body: Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.broken_image, size: 100);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Observations",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             ...widget.observations.asMap().entries.map((entry) {
//               final index = entry.key;
//               final d = entry.value;

//               final nurseName = d["doneByNurse"]?["name"] ?? "Unknown";
//               final createdAt = d["createdAt"] != null
//                   ? formatToIST(d["createdAt"])
//                   : "Unknown";

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 20),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Observation ${index + 1}",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("By Nurse: $nurseName",
//                             style: const TextStyle(fontSize: 14)),
//                         Text(createdAt,
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.grey)),
//                       ],
//                     ),
//                     const SizedBox(height: 12),

//                     if (d["vitals"] != null &&
//                         d["vitals"] is List &&
//                         d["vitals"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Vitals",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["vitals"] as List).map<Widget>((v) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(v["name"] ?? "",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.w600)),
//                                       Text(v["value"] ?? ""),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     if (d["summary"] != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Observation Summary",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 6),
//                           Text(
//                             d["summary"],
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),

//                     const SizedBox(height: 12),

//                     Row(
//                       children: [
//                         Icon(
//                           d["ismedicineOnTime"] == true
//                               ? Icons.check_circle
//                               : Icons.error,
//                           color: d["ismedicineOnTime"] == true
//                               ? Colors.green
//                               : Colors.red,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           d["ismedicineOnTime"] == true
//                               ? "Medicines taken on time"
//                               : "Medicines not taken on time",
//                           style: TextStyle(
//                             color: d["ismedicineOnTime"] == true
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(
//                       height: 12,
//                     ),

//                     if (d["supporting_images"] != null &&
//                         d["supporting_images"] is List &&
//                         d["supporting_images"].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Supporting Documents",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: (d["supporting_images"] as List)
//                                 .map<Widget>((url) {
//                               bool isPdf =
//                                   url.toString().toLowerCase().endsWith(".pdf");

//                               return GestureDetector(
//                                 onTap: () => !isPdf
//                                     ? _viewImage(url, 'filename')
//                                     : Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PdfViewerPage(
//                                             url: url,
//                                             filename: 'fileName',
//                                           ),
//                                         ),
//                                       ),
//                                 child: Container(
//                                   width: 120,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Colors.grey.shade300),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: isPdf
//                                       ? const Center(
//                                           child: Text(
//                                             "PDF Document",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       : ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             url,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return const Center(
//                                                   child: Icon(Icons.image));
//                                             },
//                                           ),
//                                         ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ObservationDialogState extends State<ObservationDialog> {
  Future<void> downloadImage(BuildContext context, String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();

      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

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
    return DateFormat("dd MMM yyyy, h:mm a").format(istTime);
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
    // Sort observations by createdAt in descending order (latest first)
    final sortedObservations = List<Map<String, dynamic>>.from(widget.observations);
    sortedObservations.sort((a, b) {
      final dateA = DateTime.parse(a["createdAt"] ?? "");
      final dateB = DateTime.parse(b["createdAt"] ?? "");
      return dateB.compareTo(dateA); // Descending order (latest first)
    });

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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

            // Observations List (Sorted - Latest First)
            ...sortedObservations.asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;

              final nurseName = d["doneByNurse"]?["name"] ?? "Unknown";
              final nurseId = d["doneByNurse"]?["userid"] ?? "Unknown";
              final createdAt = d["createdAt"] != null
                  ? formatToIST(d["createdAt"])
                  : "Unknown";

              // Calculate actual observation number (reverse index since we sorted)
              final observationNumber = sortedObservations.length - index;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
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
                    // Header Row: Observation Badge and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Observation #$observationNumber",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          createdAt,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Staff Info and Medicine Status
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.mutedBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Supporting Staff Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Supporting Staff",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  nurseName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  nurseId,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Medicine on Time Badge
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Medicine on Time",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: d["ismedicineOnTime"] == true
                                      ? Colors.green.shade500
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  d["ismedicineOnTime"] == true ? "Yes" : "No",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vitals Section
                    if (d["vitals"] != null &&
                        d["vitals"] is List &&
                        d["vitals"].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.favorite,
                                  color: AppColors.primary, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Vitals",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Display vitals in column format
                          ...(d["vitals"] as List).map<Widget>((v) {
                            return Container(
                              
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.mutedBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v["name"] ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    v["value"] ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),

                    if (d["vitals"] != null &&
                        d["vitals"] is List &&
                        d["vitals"].isNotEmpty)
                      const SizedBox(height: 16),

                    // Summary Section
                    if (d["summary"] != null &&
                        d["summary"].toString().isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note_alt_outlined,
                                  color: AppColors.primary, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Summary",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.mutedBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              d["summary"],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),

                    if (d["summary"] != null &&
                        d["summary"].toString().isNotEmpty)
                      const SizedBox(height: 16),

                    // Supporting Documents
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