
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:hospital_mobile_app/provider/supportingstaffProvider.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../routes/app_router.dart';

class SupportingStaffProfilePage extends StatefulWidget {
  const SupportingStaffProfilePage({super.key});

  @override
  State<SupportingStaffProfilePage> createState() => _SupportingStaffProfilePageState();
}

class _SupportingStaffProfilePageState extends State<SupportingStaffProfilePage> {
  late Future fetchsupportingstaffprofile;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Supportingstaffprovider supportingstaffprovider = context.read<Supportingstaffprovider>();
    fetchsupportingstaffprofile = supportingstaffprovider.getadmindetailedprofile();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    // SecureStorage secureStorage = SecureStorage();
    Supportingstaffprovider supportingstaffprovider  = context.read<Supportingstaffprovider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: fetchsupportingstaffprofile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerList();
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error fetching data"));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: supportingstaffprovider.supportingstaffdetailedprofile.length,
                        itemBuilder: (context, index) {
                          final item =
                              supportingstaffprovider.supportingstaffdetailedprofile[index];
                          final hospitalbranch =
                              item['associatedHospitalBranch'];
                          final hospital = hospitalbranch['associatedHospital'];

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Associated Hospital Branch",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 26, 136, 83),
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
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Associated Hospital",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepPurple.shade700),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                    // context.router.replaceAll([HomeRoute()]);
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
              const SizedBox(
                height: 16,
              ),
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
    Supportingstaffprovider supportingstaffprovider = context.read<Supportingstaffprovider>();

    await Future.delayed(Duration(seconds: 2));
    Constants.nursetoken =
        await secureStorage.readSecureData('nursetoken') ?? '';
    setState(() {
      fetchsupportingstaffprofile = supportingstaffprovider.getadmindetailedprofile();
    });
  }
}
