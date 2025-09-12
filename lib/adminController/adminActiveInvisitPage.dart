import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/adminController/editComplaintBox.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActiveAdminInvisitsPage extends StatefulWidget {
  const ActiveAdminInvisitsPage({super.key});

  @override
  State<ActiveAdminInvisitsPage> createState() => _ActiveAdminInvisitsPageState();
}

class _ActiveAdminInvisitsPageState extends State<ActiveAdminInvisitsPage> {
  late Future fetchactiveallinvisits;
  late Future fetchalldoctorsnurses;
  final SecureStorage secureStorage = SecureStorage();

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Adminprovider adminprovider = context.read<Adminprovider>();
    fetchactiveallinvisits = adminprovider.getactiveinvisits().then((_) {
      setState(() {
        adminprovider.filteredactiveinvisits = adminprovider.activeinvisits;
      });
    });

    fetchalldoctorsnurses = adminprovider.getdoctorsnurses();

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          // Reset to full list when search is cleared
          adminprovider.filteredactiveinvisits = adminprovider.activeinvisits;
        } else {
          adminprovider.filteredactiveinvisits =
              adminprovider.activeinvisits.where((visit) {
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
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0857C0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Clear Search',
              style: TextStyle(color: Colors.white),
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
      child: Consumer<Adminprovider>(
        builder: (context, adminprovider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                      future: fetchactiveallinvisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.76,
                              child: _buildShimmerList());
                        } else {
                          return SafeArea(
                            child: adminprovider.filteredactiveinvisits.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.76,
                                    child: _searchController.text.isNotEmpty
                                        ? _buildNoSearchResults() // <-- show no results UI if searching
                                        : const Center(
                                            child: Text(
                                              "No Out Visits to show",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.76,
                                    child: ListView.builder(
                                      itemCount: adminprovider
                                          .filteredactiveinvisits.length,
                                      itemBuilder: (context, index) {
                                        final item = adminprovider
                                            .filteredactiveinvisits[index];
                                        return ActiveInvisitModel(
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
                                                      item['createdByDoctor']?
                                                              ['name'] ??
                                                          '',
                                                  createdbydoctorid:
                                                      item['createdByDoctor']?
                                                              ['userid'] ??
                                                          '',
                                                  createdbyadmin:
                                                      item['createdByAdmin']
                                                              ?['name'] ??
                                                          '',
                                                  createdbyadminid:
                                                      item['createdByAdmin']
                                                              ?['userid'] ??
                                                          '',
                                                  cheifcomplaint:
                                                      item['chief_complaint'],
                                                  visitdate: formatDate(
                                                      item['visit_date']),
                                                  consultingdoctor:
                                                      item['consultingDoctor']
                                                          ['name'],
                                                  consultingdocid:
                                                      item['consultingDoctor']
                                                          ['userid'],
                                                  dutydoctor: item['dutyDoctor']?
                                                      ['name']??'',
                                                  dutydocid: item['dutyDoctor']?
                                                      ['userid']??'',
                                                  visitingdoctor:
                                                      item['visitingDoctor']?
                                                          ['name']??'',
                                                  visitingdocid:
                                                      item['visitingDoctor']?
                                                          ['userid']??'',
                                                  associatedstaff:
                                                      item['associatedNurse']?
                                                          ['name']??'',
                                                  supportingstaffid:
                                                      item['associatedNurse']?
                                                          ['userid']??'',
                                                );
                                              },
                                            );
                                          },
                                          editonTap: (){
                                            showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      EditComplaintDialogBox(
                                                    alldoctors: adminprovider
                                                        .alldoctors,
                                                    allnurses:
                                                        adminprovider.allnurses,
                                                    patientId: item['patientId'],
                                                    complaintId: item['id'],
                                                  ),
                                                );
                                          },
                                          viewallvisitsonTap: (){
                                            context.router.push(PatientAdminInvisitsRoute(patientId: item['patientId'], name: item['name'],
                                                ));
                                          },
                                          // startdiagnosisonTap: () {
                                          //   context.router.push(ViewDiagnosisRoute(name: item['name'], id: item['patientId'], visitingIndex: item['invisitIndex'],dischargeddate: ''));
                                          // },
                                          chiefcomplaint:
                                              item['chief_complaint'] ?? '',
                                          diagnosissummary:
                                              item['diagnosis_summary'] ?? '',
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
      fetchactiveallinvisits = doctorprovider.getactiveinvisits();
      doctorprovider.filteredactiveinvisits = doctorprovider.activeinvisits;
    });
  }
}

class ActiveInvisitModel extends StatelessWidget {
  const ActiveInvisitModel({
    super.key,
    required this.patientname,
    required this.patientId,
    required this.viewonTap,
    required this.viewallvisitsonTap,
    required this.chiefcomplaint,
    required this.diagnosissummary, required this.editonTap,
  });
  final String patientname;
  final VoidCallback viewonTap;
  final VoidCallback editonTap;
  final VoidCallback viewallvisitsonTap;
  final String patientId;
  final String chiefcomplaint;
  final String diagnosissummary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        tileColor: Colors.grey.shade50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'PatientId: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      patientId,
                      style: const TextStyle(
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
            Row(
              children: [
                const Text(
                  'Name: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  patientname,
                  style: const TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'chiefcomplaint:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              chiefcomplaint,
              style: const TextStyle(
                  fontSize: 15, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                        onPressed: viewonTap,
                        child: Row(
                          children: [
                            Text('View',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.green.shade800,
                            ),),
                            SizedBox(width: 4,),
                             Icon(
                              Icons.remove_red_eye_outlined,
                               color: Colors.green.shade800,
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.deepOrange.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                        onPressed: editonTap,
                        child: Row(
                          children: [
                            Text('Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.deepOrange.shade800,
                            ),),
                            SizedBox(width: 4,),
                             Icon(
                              Icons.edit,
                              color: Colors.deepOrange.shade800,
                            ),
                          ],
                        )),
                        SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                        onPressed: viewallvisitsonTap,
                        child: Row(
                          children: [
                            Text('All invisits',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue.shade800,
                            ),),
                            SizedBox(width: 4,),
                             Icon(
                              Icons.open_in_new,
                              color: Colors.blue.shade800,
                            ),
                          ],
                        )),
                    
                   
                  ],
                ),

            
           
          ],
        ),
      ),
    );
  }
}

class ActiveInVisitViewModel extends StatelessWidget {
  const ActiveInVisitViewModel({
    super.key,
    required this.cheifcomplaint,
    required this.visitdate,
    required this.consultingdoctor,
    required this.dutydoctor,
    required this.visitingdoctor,
    required this.associatedstaff,
    required this.name,
    required this.id,
    required this.age,
    required this.gender,
    required this.dob,
    required this.email,
    required this.phone,
    required this.consultingdocid,
    required this.dutydocid,
    required this.visitingdocid,
    required this.supportingstaffid,
    required this.createdbydoctor,
    required this.createdbydoctorid,
    required this.createdbyadmin,
    required this.createdbyadminid,
  });

  final String name;
  final String id;
  final String age;
  final String gender;
  final String dob;
  final String email;
  final String phone;
  final String createdbydoctor;
  final String createdbydoctorid;
  final String createdbyadmin;
  final String createdbyadminid;
  final String consultingdocid;
  final String dutydocid;
  final String visitingdocid;
  final String supportingstaffid;
  final String cheifcomplaint;
  final String consultingdoctor;
  final String dutydoctor;
  final String visitingdoctor;
  final String associatedstaff;
  final String visitdate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
  insetPadding: const EdgeInsets.symmetric(horizontal: 16),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Patient Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Now stack all detail rows vertically
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Patient Name: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(name)),
          ],
        ),
        SizedBox(height: 4,),
        Row(
          children: [
            const Text("Patient Id: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(id),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          children: [
            const Text("Age: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(age)),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          children: [
            const Text("Gender: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(gender)),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          children: [
            const Text("Phone: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(phone)),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          children: [
            const Text("Date of Birth: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(dob)),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Email: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(email)),
          ],
        ),
         SizedBox(height: 4,),
         if(createdbydoctor != '')
         Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Created By Doctor: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$createdbydoctor - $createdbydoctorid")),
          ],
        ),
        if(createdbydoctor == '')
         Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Created By Admin: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$createdbyadmin - $createdbyadminid")),
          ],
        ),

        const Divider(
          thickness: 2,
          color: Colors.black,
        ),
        const Divider(
          height: 0.5,
          thickness: 2,
          color: Colors.black,
        ),
        SizedBox(height: 10,),
      
        const Text(
          "Complaint Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Chief Complaint: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text(cheifcomplaint)),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Consulting Doctor: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$consultingdoctor - $consultingdocid")),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Visiting Doctor: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$visitingdoctor - $visitingdocid")),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Duty Doctor: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$dutydoctor - $dutydocid")),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Associated Staff: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(child: Text("$associatedstaff - $supportingstaffid")),
          ],
        ),
         SizedBox(height: 4,),
        Row(
          children: [
            const Text("Visit Date: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(visitdate),
          ],
        ),
      ],
    ),
  ),
);

    // return Dialog(
    //   insetPadding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             const Text(
    //               "Patient Details",
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Patient Name: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                                         child: Text(
    //                     "$name",
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
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Patient Id: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Text(
    //                   "$id",
    //                   style: const TextStyle(fontSize: 14),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Age: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                   child: Text(
    //                     "$age",
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
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Gender: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                   child: Text(
    //                     "$gender",
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
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Phone: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                   child: Text(
    //                     "$phone",
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
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Date of birth: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                   child: Text(
    //                     "$dob",
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
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "Email: ",
    //                   style:
    //                       TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Flexible(
    //                   fit: FlexFit.loose,
    //                   child: Text(
    //                     "$email",
    //                     style: const TextStyle(fontSize: 14),
    //                     softWrap: true,
    //                   ),
    //                 ),
    //                 if (createdbydoctor != '')
    //                   Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Text(
    //                         "Created By Doctor: ",
    //                         style: TextStyle(
    //                             fontSize: 14, fontWeight: FontWeight.bold),
    //                       ),
    //                       Flexible(
    //                         fit: FlexFit.loose,
    //                         child: Text(
    //                           "$createdbydoctor -",
    //                           style: const TextStyle(fontSize: 14),
    //                           softWrap: true,
    //                         ),
    //                       ),
    //                       Text(
    //                         "$createdbydoctorid",
    //                         style: TextStyle(fontSize: 14),
    //                       ),
    //                     ],
    //                   ),
    //                 if (createdbydoctor == '')
    //                   Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Text(
    //                         "Created By Admin: ",
    //                         style: TextStyle(
    //                             fontSize: 14, fontWeight: FontWeight.bold),
    //                       ),
    //                       Flexible(
    //                         fit: FlexFit.loose,
    //                         child: Text(
    //                           "$createdbyadmin -",
    //                           style: const TextStyle(fontSize: 14),
    //                           softWrap: true,
    //                         ),
    //                       ),
    //                       Text(
    //                         "${createdbyadminid}",
    //                         style: TextStyle(fontSize: 14),
    //                       ),
    //                     ],
    //                   ),

    //                 // Text(
    //                 //   "${cheifcomplaint}",
    //                 //   style: TextStyle(fontSize: 14),

    //                 // ),
    //               ],
    //             ),
    //             Divider(
    //               height: 1,
    //             ),
    //             SizedBox(
    //               height: 4,
    //             ),
    //             Divider(
    //               height: 1,
    //             ),
    //             const Text(
    //               "Complaint Details",
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             IconButton(
    //                 onPressed: () {
    //                   context.router.pop();
    //                 },
    //                 icon: const Icon(Icons.close))
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Text(
    //               "Chief Complaint: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Flexible(
    //               fit: FlexFit.loose,
    //               child: Text(
    //                 "$cheifcomplaint",
    //                 style: const TextStyle(fontSize: 14),
    //                 softWrap: true,
    //               ),
    //             ),
    //             // Text(
    //             //   "${cheifcomplaint}",
    //             //   style: TextStyle(fontSize: 14),

    //             // ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Row(
    //           children: [
    //             const Text(
    //               "Consulting Doctor: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Flexible(
    //               fit: FlexFit.loose,
    //                 child: Text(
    //               consultingdoctor,
    //               style: TextStyle(fontSize: 14),
    //               softWrap: true,
    //             )),
    //             Text(
    //               "- $consultingdocid",
    //               style: TextStyle(fontSize: 14),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Row(
    //           children: [
    //             const Text(
    //               "Visiting Doctor: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Flexible(
    //               fit: FlexFit.loose,
    //                 child: Text(
    //               visitingdoctor,
    //               style: TextStyle(fontSize: 14),
    //               softWrap: true,
    //             )),
    //             Text(
    //               "- $visitingdocid",
    //               style: TextStyle(fontSize: 14),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Row(
    //           children: [
    //             const Text(
    //               "Duty Doctor: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Flexible(
    //               fit: FlexFit.loose,
    //                 child: Text(
    //               dutydoctor,
    //               style: TextStyle(fontSize: 14),
    //               softWrap: true,
    //             )),
    //             Text(
    //               "- $dutydocid",
    //               style: TextStyle(fontSize: 14),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Row(
    //           children: [
    //             const Text(
    //               "Associated Staff: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Flexible(
    //               fit: FlexFit.loose,
    //                 child: Text(
    //               associatedstaff,
    //               style: TextStyle(fontSize: 14),
    //               softWrap: true,
    //             )),
    //             Text(
    //               "- $supportingstaffid",
    //               style: TextStyle(fontSize: 14),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Row(
    //           children: [
    //             const Text(
    //               "Visit Date: ",
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //             ),
    //             Text("${visitdate}", style: TextStyle(fontSize: 14)),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         // Row(
    //         //   children: [
    //         //     const Text(
    //         //       "Creation Time: ",
    //         //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //         //     ),
    //         //     Text("${createdat}", style: TextStyle(fontSize: 14)),
    //         //   ],
    //         // ),
    //         // const SizedBox(
    //         //   height: 8,
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
