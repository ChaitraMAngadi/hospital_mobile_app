import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/importHospitalPdfViewerPage.dart';
import 'package:hospital_mobile_app/doctorController/importHospitalViewReportButton.dart';
import 'package:hospital_mobile_app/doctorController/importPdfViewerPage.dart';
import 'package:hospital_mobile_app/doctorController/importSupportingFilesDialogBox.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/viewDiagnosisPage.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class ImportedPatientsVisitPage extends StatefulWidget {
  const ImportedPatientsVisitPage({super.key, required this.patientId, required this.name});
  final String patientId;
  final String name;

  @override
  State<ImportedPatientsVisitPage> createState() => _ImportedPatientsVisitPageState();
}

class _ImportedPatientsVisitPageState extends State<ImportedPatientsVisitPage>
    with SingleTickerProviderStateMixin {
  late Future fetchpatientinoutvisits;
  late TabController _tabController;
    final SecureStorage secureStorage = SecureStorage();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    setState(() {
      fetchpatientinoutvisits = doctorprovider.getsharedpatientinoutvisits(widget.patientId);
    });
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Shimmer loading card
  Widget buildShimmerCard() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                width: 16,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

String generateComplaintIdFromString(String createdAt) {
  // String ko DateTime me convert
  final DateTime d = DateTime.parse(createdAt).toUtc();

  String two(int n) => n.toString().padLeft(2, '0');
  String three(int n) => n.toString().padLeft(3, '0');

  return '${d.year}'
      '${two(d.month)}'
      '${two(d.day)}_'
      '${two(d.hour)}'
      '${two(d.minute)}'
      '${two(d.second)}'
      '-${three(d.millisecond)}';
}

  // Widget buildVisitCard(Map<String, dynamic> visit) {
  //   return Card(
  //     elevation: 3,
  //     margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: ListTile(
       
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(child: const Icon(Icons.medical_information, color:Color(0xFF0857C0) )),
  //           const SizedBox(width: 12,),
  //           Expanded(
  //             flex: 5,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   visit['patientName'] ?? 'Unknown Patient',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     overflow: TextOverflow.ellipsis,),
  //                     overflow: TextOverflow.ellipsis,
  //                 ),
  //                 SizedBox(height: 4,),
  //                 Text(
  //                   visit['complaint'] ?? '',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     overflow: TextOverflow.ellipsis,
  //                     // fontWeight: FontWeight.bold,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                 ),
  //                 SizedBox(height: 4,),
  //                 Text(
  //                   formatDate(visit['visit_date']?? '') ?? '',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     // fontWeight: FontWeight.bold,
  //                     ),
  //                 ),
              
  //                 const SizedBox(height: 10,),
  //                 Row(
  //                   children: [
  //                     IconButton(onPressed: (){
  //                        showDialog(
  //                                       context: context, 
  //                                       builder: (context) {
  //                                         return ImportOutvisitSupportingFilesDialogBox(
  //                                          fileUrls:visit['supporting_images'],
  //                                         );
  //                                       },
  //                                     );
  //                     }, icon: Icon(Icons.attach_file,
  //                     color: Color(0XFF0857C0),)),
  //                     SizedBox(width: 16,),
  //                     ImportPdfButton(ispatient: visit['ispatient'], complaintId:visit['complaintId'] , patientId: widget.patientId,
                      
  //                     ),
  //                   ],
  //                 ),
  //         //         ElevatedButton(
  //         //     onPressed: () {
  //         //       print(visit['ispatient']);
  //         //      if(!visit['ispatient']){
  //         //       print("object");
  //         //       MaterialPageRoute(
  //         //   builder: (context) => ImportHospitalPdfViewerPage(
  //         //     complaintId: visit['complaintId'],
  //         //     patientId:widget.patientId,
  //         //   ),
  //         // );
  //         //      }else{
  //         //       MaterialPageRoute(
  //         //   builder: (context) => ImportHospitalPdfViewerPage(
  //         //     complaintId: visit['complaintId'],
  //         //     patientId:widget.patientId,
  //         //   ),
  //         // );
  //         //      }
            
  //         //     },
  //         //     style: ElevatedButton.styleFrom(
  //         //       backgroundColor: Colors.green.shade400,
  //         //       shape: RoundedRectangleBorder(
  //         //         borderRadius: BorderRadius.circular(8),
  //         //       ),
  //         //     ),
  //         //     child: const Text(
  //         //       'View Report',
  //         //       style: TextStyle(color: Colors.white,
  //         //       fontWeight: FontWeight.bold,),
  //         //     ),
  //         //               ),
  //                       SizedBox(height: 10,)
  //               ],
  //             ),
  //           ),
  //            Expanded(
  //              child: IconButton(onPressed: (){
  //               showDialog(
  //                                             context: context,
  //                                             builder: (context) {
  //                                               return VisitViewModel(
  //                                                 cheifcomplaint: visit["complaint"],
  //                                                 height: visit["height"] ?? "",
  //                                                 weight: visit["weight"] ?? "",
  //                                                 bp: visit["bp"] ?? "",
  //                                                 temprature: visit["temperature"] ?? "",
  //                                                 heartrate: visit["heart_rate"] ?? "",
  //                                                 visitdate: formatDate(visit["visit_date"]),
  //                                               );
  //                                             },
  //                                           );
  //              }, icon: Icon(Icons.remove_red_eye,
  //                     color:Color(0xFF0857C0) ,)),
  //            )
  //         ],
  //       ),
  //       // subtitle: ElevatedButton(
  //       //     onPressed: () {
             
  //       //     },
  //       //     style: ElevatedButton.styleFrom(
  //       //       backgroundColor: Colors.green.shade400,
  //       //       shape: RoundedRectangleBorder(
  //       //         borderRadius: BorderRadius.circular(8),
  //       //       ),
  //       //     ),
  //       //     child: Text(
  //       //       'View All Diagnosis',
  //       //       style: TextStyle(color: Colors.white,
  //       //       fontWeight: FontWeight.bold,),
  //       //     ),
  //       //   ),
  //       // Text("Date: ${visit['date'] ?? 'N/A'}"),
  //       // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        
  //     ),
  //   );
  // }

  Widget buildVisitCard(Map<String, dynamic> visit) {
    return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8),bottom: Radius.circular(22)),
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                      right: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                      bottom: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                    )
                                  ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Visit Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,          
                        ),),
                        const SizedBox(height: 6,),
                        Text(formatDate(visit['visit_date']?? '') ?? '',
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,          
                        ),),
                      ],
                    ),
                    
                   Row(
                    children: [
                       Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(colors: const [Color.fromARGB(255, 170, 244, 196),Color.fromARGB(255, 185, 250, 205)])
                        ),
                         child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent)
                          ),
                          onPressed: (){
                                 showDialog(
                                                context: context, 
                                                builder: (context) {
                                                  return ImportOutvisitSupportingFilesDialogBox(
                                                   fileUrls:visit['supporting_images'],
                                                  );
                                                },
                                              );
                              }, child: Icon(Icons.attach_file,
                              color: Colors.green.shade800,)),
                       ),
                            SizedBox(width: 10,),
                            Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                                ),
                                onPressed: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return VisitViewModel(
                                                          cheifcomplaint: visit["complaint"],
                                                          height: visit["height"] ?? "",
                                                          weight: visit["weight"] ?? "",
                                                          bp: visit["bp"] ?? "",
                                                          temprature: visit["temperature"] ?? "",
                                                          heartrate: visit["heart_rate"] ?? "",
                                                          visitdate: formatDate(visit["visit_date"]),
                                                        );
                                                      },
                                                    );
                                                   },
                                                    child: Icon(Icons.remove_red_eye,
                              color:AppColors.cardBg ,)),
                            ),
                    ],
                   )
                  ],
                ),
                SizedBox(height: 16,),
                             SizedBox(
                width: double.infinity,
                 child: Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                     const Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                         Text(
                      visit['patientName'] ?? 'Unknown Patient',
                      style:  TextStyle(fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,),
                    ),
 const SizedBox(height: 6),
                                        Divider(),
 const SizedBox(height: 6),

                        const Text(
                      "Cheif Complaint",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                         Text(
                      visit['complaint'] ?? '',
                      style:  TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 6),
                    const Divider(),
                                       const SizedBox(height: 6),
                
                     ImportPdfButton(ispatient: visit['ispatient'], complaintId:visit['complaintId'] , patientId: widget.patientId,),                
                    
                    const SizedBox(height: 12),
                      ],
                    ),
                  ),
                 ),
                             ),
          
                
              ],
            ),
          ),
          
        ],
      ),
    );
    
  }

  // Widget buildInVisitCard(Map<String, dynamic> visit) {
  //   return Card(
  //     elevation: 3,
  //     margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: ListTile(
       
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(child: const Icon(Icons.medical_information, color:Color(0xFF0857C0) )),
  //           const SizedBox(width: 12,),
  //           Expanded(
  //             flex: 5,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   visit['patientName'] ?? 'Unknown Patient',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     overflow: TextOverflow.ellipsis,),
  //                     overflow: TextOverflow.ellipsis,
  //                 ),
  //                 SizedBox(height: 4,),
  //                 Text(
  //                   visit['chief_complaint'] ?? '',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     overflow: TextOverflow.ellipsis,
  //                     // fontWeight: FontWeight.bold,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                 ),
  //                 SizedBox(height: 4,),
  //                 Text(
  //                   formatDate(visit['visit_date']?? '') ?? '',
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     // fontWeight: FontWeight.bold,
  //                     ),
  //                 ),
              
  //                 const SizedBox(height: 10,),
  //                 ElevatedButton(
  //             // onPressed: () {
               
  //             // },
  //             onPressed: () async {
  //                                 await doctorprovider.getallpatientdiagnosis(
  //                                     widget.id, doctorprovider.invisitId);

  //                                 if (doctorprovider
  //                                     .patientalldiagnosis.isNotEmpty) {
  //                                   showDialog(
  //                                     context: context,
  //                                     builder: (context) {
  //                                       return DiagnosisDialog(
  //                                           diagnoses: doctorprovider
  //                                               .patientalldiagnosis);
  //                                     },
  //                                   );
  //                                 } else {
  //                                   showDialog(
  //                                     context: context,
  //                                     builder: (context) {
  //                                       return Dialog(
  //                                         insetPadding:
  //                                             const EdgeInsets.all(16),
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
  //                                   // ScaffoldMessenger.of(context).showSnackBar(
  //                                   //   const SnackBar(content: Text("No diagnoses found")),
  //                                   // );
  //                                 }
  //                               },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.green.shade400,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const Text(
  //               'View All Diagnosis',
  //               style: TextStyle(color: Colors.white,
  //               fontWeight: FontWeight.bold,),
  //             ),
  //                       ),
  //                       SizedBox(height: 10,)
  //               ],
  //             ),
  //           ),
  //            Expanded(
  //              child: IconButton(onPressed: (){
  //               showDialog(
  //                                             context: context,
  //                                             builder: (context) {
  //                                               return InVisitViewModel(
  //                                                       cheifcomplaint: visit[
  //                                                           'chief_complaint'],
  //                                                       visitdate: formatDate(
  //                                                           visit['visit_date']),
  //                                                       consultingdoctor: visit[
  //                                                               'consultingDoctor']
  //                                                           ['name'],
  //                                                       dutydoctor:
  //                                                           visit['dutyDoctor']?
  //                                                               ['name']??'',
  //                                                       visitingdoctor: visit[
  //                                                               'visitingDoctor']?
  //                                                           ['name']??'',
  //                                                       associatedstaff: visit[
  //                                                               'associatedNurse']?
  //                                                           ['name']??'');
  //                                             },
  //                                           );
  //              }, icon: Icon(Icons.remove_red_eye,
  //                     color:Color(0xFF0857C0) ,)),
  //            )
  //         ],
  //       ),
  //       // subtitle: ElevatedButton(
  //       //     onPressed: () {
             
  //       //     },
  //       //     style: ElevatedButton.styleFrom(
  //       //       backgroundColor: Colors.green.shade400,
  //       //       shape: RoundedRectangleBorder(
  //       //         borderRadius: BorderRadius.circular(8),
  //       //       ),
  //       //     ),
  //       //     child: Text(
  //       //       'View All Diagnosis',
  //       //       style: TextStyle(color: Colors.white,
  //       //       fontWeight: FontWeight.bold,),
  //       //     ),
  //       //   ),
  //       // Text("Date: ${visit['date'] ?? 'N/A'}"),
  //       // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
          ),
        ),
          title: Text(
            widget.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Refresh',
            ),
          ],
          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            indicatorAnimation: TabIndicatorAnimation.elastic,
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: AppColors.primaryGradient,
              // color: const Color(0xFF0857C0),
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade200,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'In Patient'),
              Tab(text: 'Out Patient'),
            ],
          ),
        ),
        body: Consumer<Doctorprovider>(
          builder: (context, doctorprovider, child) {
            return FutureBuilder(
              future: fetchpatientinoutvisits,
              builder: (context, snapshot) {
                // Show shimmer while loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => buildShimmerCard(),
                        ),
                        ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => buildShimmerCard(),
                        ),
                      ],
                    ),
                  );
                }
      
                // Show error if any
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
      
                // Show data
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // In Visits
                      doctorprovider.sharedpatientinvisits.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  const Text('No In Patient to show'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: doctorprovider.sharedpatientinvisits.length,
                              itemBuilder: (context, index) {
                                final visit = doctorprovider.sharedpatientinvisits[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8),bottom: Radius.circular(22)),
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                      right: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                      bottom: BorderSide(
                                        color: AppColors.accent,
                                      ),
                                    )
                                  ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Visit Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,          
                        ),),
                        const SizedBox(height: 6,),
                        Text(formatDate(visit['visit_date']?? '') ?? '',
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,          
                        ),),
                      ],
                    ),
                    
                    IconButton(onPressed: (){
                    showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return InVisitViewModel(
                                                            cheifcomplaint: visit[
                                                                'chief_complaint'],
                                                            visitdate: formatDate(
                                                                visit['visit_date']),
                                                            consultingdoctor: visit[
                                                                    'consultingDoctor']
                                                                ['name'],
                                                            dutydoctor:
                                                                visit['dutyDoctor']?
                                                                    ['name']??'',
                                                            visitingdoctor: visit[
                                                                    'visitingDoctor']?
                                                                ['name']??'',
                                                            associatedstaff: visit[
                                                                    'associatedNurse']?
                                                                ['name']??'');
                                                  },
                                                );
                   }, icon: Icon(Icons.remove_red_eye,
                          color:Color(0xFF0857C0) ,)),
                  ],
                ),
                SizedBox(height: 16,),
                             SizedBox(
                width: double.infinity,
                 child: Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                     const Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                         Text(
                      visit['patientName'] ?? 'Unknown Patient',
                      style:  TextStyle(fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,),
                    ),
 const SizedBox(height: 6),
                                        Divider(),
 const SizedBox(height: 6),

                        const Text(
                      "Cheif Complaint",
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                         Text(
                      visit['chief_complaint'] ?? '',
                      style:  TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 6),
                    const Divider(),
                                       const SizedBox(height: 6),
                
                       Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                         child: ElevatedButton(
                                           // onPressed: () {
                                            
                                           // },
                                                     onPressed: () async {
                                  await doctorprovider.getimportpatientalldiagnosis(
                                      widget.patientId, visit['id'] );

                                  if (doctorprovider
                                      .importpatientalldiagnosis.isNotEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DiagnosisDialog(
                                          id: widget.patientId,
                                            diagnoses: doctorprovider
                                                .importpatientalldiagnosis);
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
                                           style: ElevatedButton.styleFrom(
                                             backgroundColor: Colors.transparent,
                                             shadowColor: Colors.transparent,
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(8),
                                             ),
                                           ),
                                           child: const Text(
                                             'View All Diagnosis',
                                             style: TextStyle(color: Colors.white,
                                             fontWeight: FontWeight.bold,),
                                           ),
                              ),
                       ),                 
                    
                    const SizedBox(height: 12),
                      ],
                    ),
                  ),
                 ),
                             ),
          
                
              ],
            ),
          ),
          
        ],
      ),
    );
    //                             Card(
    //   elevation: 3,
    //   margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   child: ListTile(
       
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(child: const Icon(Icons.medical_information, color:Color(0xFF0857C0) )),
    //         const SizedBox(width: 12,),
    //         Expanded(
    //           flex: 5,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 visit['patientName'] ?? 'Unknown Patient',
    //                 style: const TextStyle(
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.bold,
    //                   overflow: TextOverflow.ellipsis,),
    //                   overflow: TextOverflow.ellipsis,
    //               ),
    //               SizedBox(height: 4,),
    //               Text(
    //                 visit['chief_complaint'] ?? '',
    //                 style: const TextStyle(
    //                   fontSize: 15,
    //                   overflow: TextOverflow.ellipsis,
    //                   // fontWeight: FontWeight.bold,
    //                   ),
    //                   overflow: TextOverflow.ellipsis,
    //               ),
    //               SizedBox(height: 4,),
    //               Text(
    //                 formatDate(visit['visit_date']?? '') ?? '',
    //                 style: const TextStyle(
    //                   fontSize: 15,
    //                   // fontWeight: FontWeight.bold,
    //                   ),
    //               ),
              
    //               const SizedBox(height: 10,),
    //               ElevatedButton(
    //           // onPressed: () {
               
    //           // },
              // onPressed: () async {
              //                     await doctorprovider.getimportpatientalldiagnosis(
              //                         widget.patientId, visit['id'] );

              //                     if (doctorprovider
              //                         .importpatientalldiagnosis.isNotEmpty) {
              //                       showDialog(
              //                         context: context,
              //                         builder: (context) {
              //                           return DiagnosisDialog(
              //                             id: widget.patientId,
              //                               diagnoses: doctorprovider
              //                                   .importpatientalldiagnosis);
              //                         },
              //                       );
              //                     } else {
              //                       showDialog(
              //                         context: context,
              //                         builder: (context) {
              //                           return Dialog(
              //                             insetPadding:
              //                                 const EdgeInsets.all(16),
              //                             shape: RoundedRectangleBorder(
              //                                 borderRadius:
              //                                     BorderRadius.circular(16)),
              //                             child: Padding(
              //                               padding: EdgeInsets.all(30),
              //                               child: Column(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 children: [
              //                                   Text(
              //                                       "No Diagnosis records found for this visit."),
              //                                 ],
              //                               ),
              //                             ),
              //                           );
              //                         },
              //                       );
              //                       // ScaffoldMessenger.of(context).showSnackBar(
              //                       //   const SnackBar(content: Text("No diagnoses found")),
              //                       // );
              //                     }
              //                   },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.green.shade400,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //           ),
    //           child: const Text(
    //             'View All Diagnosis',
    //             style: TextStyle(color: Colors.white,
    //             fontWeight: FontWeight.bold,),
    //           ),
    //                     ),
    //                     SizedBox(height: 10,)
    //             ],
    //           ),
    //         ),
    //          Expanded(
    //            child: IconButton(onPressed: (){
    //             showDialog(
    //                                           context: context,
    //                                           builder: (context) {
    //                                             return InVisitViewModel(
    //                                                     cheifcomplaint: visit[
    //                                                         'chief_complaint'],
    //                                                     visitdate: formatDate(
    //                                                         visit['visit_date']),
    //                                                     consultingdoctor: visit[
    //                                                             'consultingDoctor']
    //                                                         ['name'],
    //                                                     dutydoctor:
    //                                                         visit['dutyDoctor']?
    //                                                             ['name']??'',
    //                                                     visitingdoctor: visit[
    //                                                             'visitingDoctor']?
    //                                                         ['name']??'',
    //                                                     associatedstaff: visit[
    //                                                             'associatedNurse']?
    //                                                         ['name']??'');
    //                                           },
    //                                         );
    //            }, icon: Icon(Icons.remove_red_eye,
    //                   color:Color(0xFF0857C0) ,)),
    //          )
    //       ],
    //     ),
    //     // subtitle: ElevatedButton(
    //     //     onPressed: () {
             
    //     //     },
    //     //     style: ElevatedButton.styleFrom(
    //     //       backgroundColor: Colors.green.shade400,
    //     //       shape: RoundedRectangleBorder(
    //     //         borderRadius: BorderRadius.circular(8),
    //     //       ),
    //     //     ),
    //     //     child: Text(
    //     //       'View All Diagnosis',
    //     //       style: TextStyle(color: Colors.white,
    //     //       fontWeight: FontWeight.bold,),
    //     //     ),
    //     //   ),
    //     // Text("Date: ${visit['date'] ?? 'N/A'}"),
    //     // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        
    //   ),
    // );
                              },
                            ),
      
                      // Out Visits
                      doctorprovider.sharedpatientoutvisits.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  const Text('No Out Patient to show'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: doctorprovider.sharedpatientoutvisits.length,
                              itemBuilder: (context, index) {
                                final visit = doctorprovider.sharedpatientoutvisits[index];
                                return buildVisitCard(visit);
                              },
                            ),
                    ],
                  ),
                );
              },
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
      fetchpatientinoutvisits = doctorprovider.getsharedpatientinoutvisits(widget.patientId);
      // doctorprovider.filteredactiveinvisits = doctorprovider.activeinvisits;
    });
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
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(22))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      child: const Icon(Icons.monitor_heart, color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Complaint Details",
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
          
                /// CHIEF COMPLAINT
                _highlightCard(
                  label: "CHIEF COMPLAINT",
                  value: cheifcomplaint,
                ),
          
                const SizedBox(height: 16),
                _divider(),
          
                /// VITALS GRID
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (height.isNotEmpty)
                      _smallCard("HEIGHT", height, Icons.height),
                    if (weight.isNotEmpty)
                      _smallCard("WEIGHT", weight, Icons.monitor_weight),
                    if (temprature.isNotEmpty)
                      _smallCard(
                          "TEMPERATURE", temprature, Icons.thermostat),
                    if (bp.isNotEmpty)
                      _smallCard(
                          "BLOOD PRESSURE", bp, Icons.favorite),
                    if (heartrate.isNotEmpty)
                      _smallCard(
                          "HEART RATE", heartrate, Icons.monitor_heart),
                  ],
                ),
          
                const SizedBox(height: 16),
          
                /// VISIT DATE
                _infoCard(
                  icon: Icons.calendar_today,
                  label: "VISIT DATE",
                  value: visitdate,
                ),
              ],
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
      color: Colors.red.shade200,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  /// Highlight card (Chief Complaint)
  Widget _highlightCard({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:  TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Small vitals card
  Widget _smallCard(String label, String value, IconData icon) {
    return Container(
      width: 160,
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
              Icon(icon, size: 16, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Info card (Visit Date)
  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                       TextStyle(fontSize: 12,
                       fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
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
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  child: const Icon(Icons.monitor_heart, color: Colors.red),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Complaint Details",
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

            /// CHIEF COMPLAINT
            _highlightCard(
              label: "CHIEF COMPLAINT",
              value: cheifcomplaint,
            ),

            const SizedBox(height: 16),
            _divider(),

            /// DOCTORS / STAFF
            _infoRow(
              icon: Icons.person,
              label: "CONSULTING DOCTOR",
              value: consultingdoctor,
            ),

            if (visitingdoctor.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoRow(
                icon: Icons.medical_services_outlined,
                label: "VISITING DOCTOR",
                value: visitingdoctor,
              ),
            ],

            if (dutydoctor.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoRow(
                icon: Icons.local_hospital_outlined,
                label: "DUTY DOCTOR",
                value: dutydoctor,
              ),
            ],

            if (associatedstaff.isNotEmpty) ...[
              const SizedBox(height: 12),
              _infoRow(
                icon: Icons.groups_outlined,
                label: "ASSOCIATED STAFF",
                value: associatedstaff,
              ),
            ],

            const SizedBox(height: 16),
            _divider(),

            /// VISIT DATE
            _dateCard(
              icon: Icons.calendar_today,
              label: "VISIT DATE",
              value: visitdate,
            ),
          ],
        ),
      ),
    );
  }

  /// Divider
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.red.shade200,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  /// Highlight Card (Chief Complaint)
  Widget _highlightCard({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Info Row (Doctor / Staff)
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.red),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 220,
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Visit Date Card
  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.red),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}