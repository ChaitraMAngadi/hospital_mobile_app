import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/downloadPdfButton.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/supportingDocsDialogbox.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class PatientAdminOutvisitsPage extends StatefulWidget {
  const PatientAdminOutvisitsPage({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  State<PatientAdminOutvisitsPage> createState() => _PatientAdminOutvisitsPageState();
}


class _PatientAdminOutvisitsPageState extends State<PatientAdminOutvisitsPage> {
  late Future fetchoutvisits;
  late Future fetchalldoctorsnurses;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    Adminprovider adminprovider =
        context.read<Adminprovider>();
    fetchoutvisits = adminprovider.getpatientoutvisits(widget.patientId);
    fetchalldoctorsnurses = adminprovider.getdoctorsnurses();

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
        }, icon: const Icon(Icons.arrow_back,
        color: Colors.white,)),
        title: const Text(
                "Patient OutVisit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
        child: Consumer<Adminprovider>(
          builder: (context, adminprovider, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Show the dialog
                        
                            showDialog(
                              context: context,
                              builder: (context) {
                                return RegisterVisitModel(
                                  patientId: widget.patientId,
                                  alldoctors: adminprovider.alldoctors,
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
                              Text("Add New OPD Visit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: fetchoutvisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Show shimmer loading instead of CircularProgressIndicator
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.81,
                            child: _buildShimmerList(),
                          );
                        } else {
                          return SafeArea(
                            child: adminprovider.patientoutvisits.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.81,
                                    child: const Center(child: Text(
                                          "No Outvisits for this pateint \nPlaese add Outvisit",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),))
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.81,
                                    child: ListView.builder(
                                      itemCount: adminprovider.patientoutvisits.length,
                                      itemBuilder: (context, index) {
                                        final item = adminprovider.patientoutvisits[index];
                                       
                                      
                                        return VisitModel(
                                          indexnum: index+1,
                                          cheifcomplaint: item['chief_complaint'],
                                          visitdate: formatDate(item['visit_date']),
                                          complaintId: item['id'],
                                          patientId: widget.patientId,
                                          // createdtime: 'formatDate(complaint["createdAt"])',
                                          
                                          viewontap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return VisitViewModel(
                                                  cheifcomplaint: item["chief_complaint"],
                                                  height: item["height"] ?? "",
                                                  weight: item["weight"] ?? "",
                                                  bp: item["bp"] ?? "",
                                                  temprature: item["temperature"] ?? "",
                                                  heartrate: item["heart_rate"] ?? "",
                                                  visitdate: formatDate(item["visit_date"]),
                                                  associateddoctor: '${item['associatedDoctor']['name']}, ${item['associatedDoctor']['userid']}',
                                                );
                                              },
                                            );
                                          }, isDiagnosed: item['isDiagnosed'],
                                        
                                         
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
    Adminprovider adminprovider =
        context.read<Adminprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    setState(() {
      fetchoutvisits = adminprovider.getpatientoutvisits(widget.patientId);
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
//     required this.complaintId,
//     required this.patientId, required this.isDiagnosed,
//   });

//   final String cheifcomplaint;
//   final String visitdate;
//   // final List<dynamic> supportingimages;
//   final String complaintId;
//   final String patientId;
//   final bool isDiagnosed;

//   // final String createdtime;
//   final VoidCallback viewontap;

//   @override
//   Widget build(BuildContext context) {
   
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16
//       ),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: 16,
//             top: 16,
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
//                   IconButton(
//                       onPressed: viewontap,
//                       icon: const Icon(
//                         Icons.remove_red_eye,
//                         color: Color(0Xff2556B9),
//                       )),
                 
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
//                 height: 4,
//               ),
//                Text(isDiagnosed? 'Visit Completed': 'Not Visited',
//                  style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: isDiagnosed ? Colors.green.shade700 : Colors.red.shade700,
//                  ),
//                  )
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
    required this.complaintId,
    required this.patientId,
    required this.isDiagnosed, required this.indexnum,
  });

  final String cheifcomplaint;
  final String visitdate;
  final String complaintId;
  final String patientId;
  final bool isDiagnosed;
  final VoidCallback viewontap;
  final int indexnum;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 16, vertical: 8) ,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top row: Visit no + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Visit #${indexnum.toString()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDiagnosed
                            ? Colors.green.shade500
                            : Colors.red.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDiagnosed ? "Completed" : "Not Visited",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              
                const SizedBox(height: 14),
              
                /// Visit Date
                const Text(
                  "VISIT DATE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  visitdate,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              
                const SizedBox(height: 14),
              
                /// Chief Complaint
                const Text(
                  "CHIEF COMPLAINT",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cheifcomplaint,
                  style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,),
                ),
              
                const SizedBox(height: 16),
              
                /// View Details button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: viewontap,
                    icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
                    label: const Text(
                      "View Details",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
//     required this.visitdate, required this.associateddoctor,
//   });

//   final String cheifcomplaint;
//   final String associateddoctor;
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
//                   "Associated Doctor: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Flexible(
//                   child: Text(
//                     "$associateddoctor",
//                     style: const TextStyle(fontSize: 14),
//                     softWrap: true,
//                   ),
//                 ),
                
//               ],
//             ),
//             const SizedBox(
//               height: 8,
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
               
//               ],
//             ),
//             SizedBox(height: 8,),
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
    required this.associateddoctor,
  });

  final String cheifcomplaint;
  final String associateddoctor;
  final String height;
  final String weight;
  final String bp;
  final String temprature;
  final String heartrate;
  final String visitdate;

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.red.shade200, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Out-Visit Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => context.router.pop(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Chief Complaint
              _infoTile(
                icon: Icons.assignment_outlined,
                label: "Chief Complaint",
                value: cheifcomplaint,
              ),

              const SizedBox(height: 12),

              /// Associated Doctor
              _infoTile(
                icon: Icons.person_outline,
                label: "Associated Doctor",
                value: associateddoctor,
              ),

              const SizedBox(height: 12),

              /// Visit Date
              _infoTile(
                icon: Icons.calendar_today_outlined,
                label: "Visit Date",
                value: visitdate,
              ),

              const SizedBox(height: 12),

              /// Vitals (conditional – same logic)
              if (height.isNotEmpty)
                _infoTile(
                  icon: Icons.height,
                  label: "Height",
                  value: height,
                ),

              if (weight.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoTile(
                  icon: Icons.monitor_weight_outlined,
                  label: "Weight",
                  value: weight,
                ),
              ],

              if (temprature.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoTile(
                  icon: Icons.thermostat_outlined,
                  label: "Temperature",
                  value: temprature,
                ),
              ],

              if (bp.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoTile(
                  icon: Icons.favorite_outline,
                  label: "Blood Pressure",
                  value: bp,
                ),
              ],

              if (heartrate.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoTile(
                  icon: Icons.monitor_heart_outlined,
                  label: "Heart Rate",
                  value: heartrate,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


class RegisterVisitModel extends StatefulWidget {
  const RegisterVisitModel({
    super.key,
    required this.patientId, required this.alldoctors,
  });
  final String patientId;
  final List<Map<String, dynamic>> alldoctors;



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

    Map<String, dynamic>? selectedConsultingDoctor;


  final formkey = GlobalKey<FormState>();

  DateTime today = DateTime.now();

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Adminprovider adminprovider =
        context.read<Adminprovider>();
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
               SizedBox(height: 8,), 
                const Text("Consulting Doctor*",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.alldoctors,
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedConsultingDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Consulting Doctor",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                           validator: (value) {
                    if (value == null) {
                      return "Please select a Consulting Doctor";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedConsultingDoctor = value;
                    });
                    debugPrint("Consulting Doctor ID: ${value?['userid']}");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient:adminprovider.addingoutvisit? LinearGradient(colors: [
                      Colors.grey,Colors.grey
                    ]): AppColors.primaryGradient,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:adminprovider.addingoutvisit? null: () async {
                      if (formkey.currentState!.validate()) {
                         setState(() {
                                  adminprovider.addingoutvisit = true;
                                });
                        adminprovider.addoutvisit(
                          widget.patientId,
                          cheifcomplaintController.text,
                          heartrateController.text,
                          weightController.text,
                          bpController.text,
                          temperatureController.text,
                          heartrateController.text,
                          selectedConsultingDoctor?['userid'],
                          context,
                        );

                        await adminprovider.getpatientoutvisits(widget.patientId);
                      }

                      // context.router.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:adminprovider.addingoutvisit? Colors.transparent: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Text("Submit",
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
