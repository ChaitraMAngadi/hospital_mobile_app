import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/downloadPdfButton.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/patientOutvisitsPage.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodaysOutvisitsPage extends StatefulWidget {
  const TodaysOutvisitsPage({super.key});

  @override
  State<TodaysOutvisitsPage> createState() => _TodaysOutvisitsPageState();
}

class _TodaysOutvisitsPageState extends State<TodaysOutvisitsPage> {
  late Future fetchtodaysoutvisits;
  final SecureStorage secureStorage = SecureStorage();

  TextEditingController _searchController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   HomePageProvider homePageProvider = context.read<HomePageProvider>();
  //   Patientpageprovider patientpageprovider =
  //       context.read<Patientpageprovider>();
  //   fetchallpatients = patientpageprovider.getallpatients();
  //   filteredPatients = patientpageprovider.allpatients;
  //   print(filteredPatients);
  //   fetchdoctor = homePageProvider.getdoctordetails();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   Doctorprovider doctorprovider = context.read<Doctorprovider>();
  //   fetchtodaysoutvisits = doctorprovider.gettodaysoutvisits().then((_) {
  //     setState(() {
  //       doctorprovider.filteredvisits = doctorprovider.gettodaysvisits;
  //     });
  //   });

  //   _searchController.addListener(() {
  //     final query = _searchController.text.toLowerCase();
  //     setState(() {
  //       doctorprovider.filteredvisits =
  //           doctorprovider.gettodaysvisits.where((visit) {
  //         final name = visit['name']?.toLowerCase() ?? '';
  //         final chiefcomplaint = visit['chief_complaint']?.toLowerCase() ?? '';
  //         final id = visit['patientId']?.toLowerCase() ?? '';
  //         return name.contains(query) ||
  //             id.contains(query) ||
  //             chiefcomplaint.contains(query);
  //       }).toList();
  //     });
  //   });
  // }

  @override
void initState() {
  super.initState();
  Doctorprovider doctorprovider = context.read<Doctorprovider>();
  fetchtodaysoutvisits = doctorprovider.gettodaysoutvisits().then((_) {
    setState(() {
      doctorprovider.filteredvisits = doctorprovider.gettodaysvisits;
    });
  });

  _searchController.addListener(() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Reset to full list when search is cleared
        doctorprovider.filteredvisits = doctorprovider.gettodaysvisits;
      } else {
        doctorprovider.filteredvisits =
            doctorprovider.gettodaysvisits.where((visit) {
          final name = visit['name']?.toLowerCase() ?? '';
          final chiefcomplaint = visit['chief_complaint']?.toLowerCase() ?? '';
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
      child: Consumer<Doctorprovider>(
        builder: (context, doctorprovider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       context.router.push(RegisterPatientRoute());
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color(0xFF0857C0),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  //     ),
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(Icons.person_add_alt_1_outlined,
                  //             color: Colors.white),
                  //         SizedBox(
                  //           width: 6,
                  //         ),
                  //         Text("Register Patient",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               color: Colors.white,
                  //             )),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                      future: fetchtodaysoutvisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.76,
                              child: _buildShimmerList());
                        } else {
                          return SafeArea(
  child: doctorprovider.filteredvisits.isEmpty
      ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.76,
          child: _searchController.text.isNotEmpty
              ? _buildNoSearchResults() // <-- show no results UI if searching
              : const Center(
                  child: Text(
                    "No Out Visits to show",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        )
      : SizedBox(
          height: MediaQuery.of(context).size.height * 0.76,
          child: ListView.builder(
            itemCount: doctorprovider.filteredvisits.length,
            itemBuilder: (context, index) {
              final item = doctorprovider.filteredvisits[index];
              return TodaysVisitModel(
                patientname: item['name'],
                patientId: item['patientId'],
                viewonTap: () {
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
                                                );
                                              },
                                            );
                },
                startdiagnosisonTap: () {
                   context.router.push(
                                              DiagnosisRoute(
                                              patientId: item['patientId'],
                                              complaintId:item['id'],
                                            ));
                },
                supportingimagesonTap: () {},
                chiefcomplaint: item['chief_complaint'] ?? '',
                diagnosissummary: item['diagnosis_summary'] ?? '',
                complaintId: item['id'],
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
      fetchtodaysoutvisits = doctorprovider.gettodaysoutvisits();
      doctorprovider.filteredvisits = doctorprovider.gettodaysvisits;
    });
  }
}

class TodaysVisitModel extends StatelessWidget {
  const TodaysVisitModel({
    super.key,
    required this.patientname,
    required this.patientId,
    required this.viewonTap,
    required this.startdiagnosisonTap,
    required this.supportingimagesonTap,
    required this.chiefcomplaint,
    required this.diagnosissummary,
    required this.complaintId,
  });
  final String patientname;
  final VoidCallback viewonTap;
  final VoidCallback startdiagnosisonTap;
  final VoidCallback supportingimagesonTap;
  final String patientId;
  final String complaintId;
  final String chiefcomplaint;
  final String diagnosissummary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16,),
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
                    Text(
                      'PatientId: ',
                      style: const TextStyle(
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
                Row(
                  children: [
                    IconButton(
                    onPressed: viewonTap,
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Color(0xFF0857C0),
                    )),
                    SizedBox(width: 6,),
                IconButton(
                    onPressed: supportingimagesonTap,
                    icon: const Icon(
                      Icons.attach_file,
                      color: Color(0xFF0857C0),
                    ))
                  ],
                )
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
                  'chiefcomplaint: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  chiefcomplaint,
                  style: const TextStyle(fontSize: 15,
                  overflow: TextOverflow.ellipsis,),
                  
                ),
            const SizedBox(
              height: 16,
            ),
            if (diagnosissummary == "")
              ElevatedButton(
                onPressed: startdiagnosisonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text("Start Diagnosis",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
            if (diagnosissummary != "")
              DownloadPdfButton(complaintId: complaintId, patientId: patientId),

               const SizedBox(
              height: 16,
            ),
          ],
        ),
        
      ),
    );
  }
}
