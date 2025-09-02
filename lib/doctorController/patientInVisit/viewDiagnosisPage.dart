import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/downloadInvisitPdfButton.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ViewDiagnosisPage extends StatefulWidget {
  final String name;
  final String id;
  final int visitingIndex;

  const ViewDiagnosisPage({super.key, required this.name, required this.id, required this.visitingIndex,});

  @override
  State<ViewDiagnosisPage> createState() => _ViewDiagnosisPageState();
}

class _ViewDiagnosisPageState extends State<ViewDiagnosisPage> {
  late Future fetchpatientdiagnosis;

      final SecureStorage secureStorage = SecureStorage();

  @override
void initState() {
  super.initState();
  Doctorprovider doctorprovider = context.read<Doctorprovider>();
  fetchpatientdiagnosis = doctorprovider.getpatientdiagnosis(widget.id, widget.visitingIndex);


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
      appBar: AppBar(title: Text('${widget.name} - ${widget.id}',
      overflow: TextOverflow.ellipsis,),),
        body: RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Consumer<Doctorprovider>(
        builder: (context, doctorprovider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // context.router.push(RegisterPatientRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0857C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          child: Text("Discharge Patient",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(width: 16,),
                        ElevatedButton(
                          onPressed: () {
                            // context.router.push(RegisterPatientRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0857C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          child: Text("Add diagnosis",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    
                    RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: FutureBuilder(
                        future: fetchpatientdiagnosis,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: _buildShimmerList());
                          } else {
                            return SafeArea(
                  child: doctorprovider.patientdiagnosis.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height*0.8,
                          child:  const Center(
                    child: Text(
                      "No Diagnosis to show",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height *0.8,
                          child: ListView.builder(
                            itemCount: doctorprovider.patientdiagnosis.length,
                            itemBuilder: (context, index) {
                final item = doctorprovider.patientdiagnosis[index];
                return DiagnosisModel(
                  
                  patientId: widget.id,
                  chiefcomplaint: item['complaint'] ?? '',
                  complaintId: 'item',
                  createdat: formatDate(item['createdAt']),
                  doneby: item['doneBy']['name'],
                
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
      fetchpatientdiagnosis = doctorprovider.getpatientdiagnosis(widget.id, widget.visitingIndex);
     
    });
  }
}

class DiagnosisModel extends StatelessWidget {
  const DiagnosisModel({
    super.key,
    // required this.viewonTap,
 
    required this.complaintId, required this.chiefcomplaint, required this.doneby, required this.createdat, required this.patientId,
  });
  // final VoidCallback viewonTap;
  final String complaintId;
  final String chiefcomplaint;
  final String doneby;
  final String createdat;
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16,top: 16),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        tileColor: Colors.grey.shade50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                  'chiefcomplaint: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    chiefcomplaint,
                    style: const TextStyle(fontSize: 15,
                    overflow: TextOverflow.visible,),
                    
                  ),
                ),
                ],
              ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    const Text(
                      'Done by: ',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      doneby,
                      style: const TextStyle(fontSize: 15,
                      overflow: TextOverflow.ellipsis,),
                      
                    ),
                  ],
                ),
                 SizedBox(height: 8,),
                Row(
                  children: [
                    const Text(
                      'Created at: ',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      createdat,
                      style: const TextStyle(fontSize: 15,
                      overflow: TextOverflow.ellipsis,),
                      
                    ),
                  ],
                ),
            const SizedBox(
              height: 16,
            ),             
              DownloadInvisitPdfButton(visitIndex: '0', patientId: patientId,),

               const SizedBox(
              height: 16,
            ),
          ],
        ),
        
      ),
    );
  }
}
