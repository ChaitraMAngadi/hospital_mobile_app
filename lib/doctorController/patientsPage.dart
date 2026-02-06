

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();

  late Doctorprovider doctorprovider;
  // late HomePageProvider homePageProvider;

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Timer? _debounceTimer;
  String _currentSearchQuery = '';
  bool _isSearching = false; // Add this flag to track search state

  @override
  void initState() {
    super.initState();
    // homePageProvider = context.read<HomePageProvider>();
    doctorprovider = context.read<Doctorprovider>();

    _fetchInitialData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMorePatients();
      }
    });

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      
      _debounceTimer?.cancel();
      
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (_currentSearchQuery != query) {
          _currentSearchQuery = query;
          _performSearch(query);
        }
      });
    });
  }

  Future<void> _fetchInitialData() async {
    await doctorprovider.getPatientsByPageWithSearch(_currentPage, _currentSearchQuery);
    // await homePageProvider.getdoctordetails();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _isSearching = true; 
      doctorprovider.allpatients.clear();
      doctorprovider.filteredPatients.clear();
    });

    await doctorprovider.getPatientsByPageWithSearch(_currentPage, query);
    
    setState(() {
      _hasMore = doctorprovider.allpatients.isNotEmpty;
      _isSearching = false; // Reset searching flag
    });
  }

  Future<void> _loadMorePatients() async {
    setState(() => _isLoadingMore = true);
    _currentPage += 1;

    final previousLength = doctorprovider.allpatients.length;
    await doctorprovider.getPatientsByPageWithSearch(_currentPage, _currentSearchQuery);
    final newLength = doctorprovider.allpatients.length;

    if (newLength == previousLength) {
      _hasMore = false;
    }

    setState(() => _isLoadingMore = false);
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _isSearching = false; // Reset searching flag
      doctorprovider.allpatients.clear();
      doctorprovider.filteredPatients.clear();
    });
    await _fetchInitialData();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return '';
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  // Add this method for "No search results found" UI
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
              _currentSearchQuery = '';
              _performSearch('');
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

  Widget _buildShimmerBox({
    required double width, 
    required double height, 
    double borderRadius = 8
  }) {
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
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Consumer<Doctorprovider>(
          builder: (context, doctorprovider, child) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Register Patient Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            )
          ],
        ),
                          child: ElevatedButton(
                            // onPressed: (){},
                            onPressed: () => context.router.push(ImportPatientsRoute()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.medical_services, color: Colors.white),
                                SizedBox(width: 4),
                                Text("Import Patient", style: TextStyle(fontSize: 15, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            )
          ],
        ),
                          child: ElevatedButton(
                            // onPressed: (){},
                            onPressed: () => context.router.push(RegisterPatientRoute()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                                SizedBox(width: 4),
                                Text("Register Patient", style: TextStyle(fontSize: 15, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Patient by id or name...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _currentSearchQuery = '';
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // Main content area
                  Expanded(
                    child: _buildMainContent(doctorprovider),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(Doctorprovider doctorprovider) {
    // Show shimmer while searching or initial load
    if (_isSearching || (_currentPage == 1 && doctorprovider.allpatients.isEmpty && _isLoadingMore)) {
      return _buildShimmerList();
    }
    
    // Show "No search results found" if search query exists but no results
    if (_currentSearchQuery.isNotEmpty && doctorprovider.allpatients.isEmpty) {
      return _buildNoSearchResults();
    }
    
    // Show shimmer for initial load (when no search query)
    if (doctorprovider.allpatients.isEmpty && _currentSearchQuery.isEmpty) {
      return _buildShimmerList();
    }
    
    // Show the actual list
    return ListView.builder(
      controller: _scrollController,
      itemCount: doctorprovider.allpatients.length + (_hasMore && _isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < doctorprovider.allpatients.length) {
          final sorted = doctorprovider.allpatients
            ..sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
          final item = sorted[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTileModel(patientname: item['name'], patientId: item['patientId'], 
            viewonTap: (){
              showDialog(
                context: context,
                builder: (context) {
                  return item["adminDetails"] == null
                      ? ViewModel(
                          name: item['name'],
                          patientid: item['patientId'],
                          email: item['email'] ?? "",
                          phonenumber: item['phone'] ?? 0,
                          dob: formatDate(item['DOB'] ?? ""),
                          age: item['age'] ?? "",
                          gender: item['gender'] ?? "",
                          createdbyadmin: "",
                          adminame: "",
                          // createdbydoctor: "",
                          createdbydoctor: item['doctorDetails']['name'] ,
                          doctoruserid:item['doctorDetails']['userid'] ,
                          adminuserid: '',
                          createdat: formatDate(item['createdAt']),
                        )
                      : ViewModel(
                          name: item['name'],
                          patientid: item['patientId'],
                          email: item['email'] ?? "",
                          phonenumber: item['phone'] ?? 0,
                          dob: formatDate(item['DOB'] ?? ""),
                          age: item['age'] ?? "",
                          gender: item['gender'] ?? "",
                          createdbyadmin: item["adminDetails"]['name'] ?? "",
                          adminame: item["adminDetails"]["name"],
                          adminuserid:item["adminDetails"]["userid"] ,
                          doctoruserid: '',
                          createdbydoctor: "",
                          // createdbydoctor: "${homePageProvider.doctordetails.first["name"]} - ${homePageProvider.doctordetails.first["userid"]}",
                          createdat: formatDate(item['createdAt']),
                        );
                },
              );
              
            }, editonTap: (){
              context.router.push(EditPatientRoute(patientId:item['patientId'] ));
            }, outvisitonTap: (){
              context.router.push(PatientOutvisitsRoute(patientId: item['patientId']));
            }, invisitonTap: (){
              context.router.push(PatientInvisitsRoute(patientId: item['patientId'], name: item['name']));
            },),
          );
        } else if (_hasMore && _isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


// class ListTileModel extends StatelessWidget {
//   const ListTileModel({
//     super.key,
  
//     required this.patientname,
//     required this.patientId, required this.viewonTap, required this.editonTap, required this.outvisitonTap, required this.invisitonTap,
    
//   });
//   final String patientname;
//   final VoidCallback viewonTap;
//   final VoidCallback editonTap;
//   final VoidCallback outvisitonTap;
//   final VoidCallback invisitonTap;
//   final String patientId;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ListTile(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8))),
//         tileColor: Colors.grey.shade50,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
           
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   patientname,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(onPressed: viewonTap, icon: const Icon(Icons.remove_red_eye_outlined,
//                 color:Color(0xFF0857C0) ,))
//               ],
//             ),
//             Text(
//               patientId,
//               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10,),
            
//           ],
//         ),
        
//         subtitle:
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                      style: ElevatedButton.styleFrom(
//                         backgroundColor:Colors.blue.shade100,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 6, vertical: 12),
//                       ),
//                     onPressed: invisitonTap, child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children:
//                      [

//                     Text("IPD",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0857C0),
//                     ),),
//                     SizedBox(width: 4,),
//                     Icon(Icons.open_in_new,
//                     color: Color(0xFF0857C0),),
//                   ],)),
//                 ),
//                 SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton(
//                      style: ElevatedButton.styleFrom(
//                         backgroundColor:Colors.green.shade100,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 6, vertical: 12),
//                       ),
//                     onPressed: outvisitonTap,
//                      child:  Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                     Text("OPD",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green.shade700,
//                     ),),
//                     SizedBox(width: 4,),
//                     Icon(Icons.open_in_new,
//                     color: Colors.green.shade700,),
//                   ],)),
//           ),
//           SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                      style: ElevatedButton.styleFrom(
//                         backgroundColor:Colors.brown.shade100,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 6, vertical: 12),
//                       ),
//                     onPressed: editonTap,
//                      child:  Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                     Text("Edit",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.brown.shade700,
//                     ),),
//                     SizedBox(width: 4,),
//                     Icon(Icons.edit_square,
//                     color: Colors.brown.shade700,),
//                   ],)),
//                 ),
//                 // IconButton(onPressed: editonTap, icon: const Icon(Icons.edit_square,
//                 // color:Color(0xFF0857C0) ,))
          
//         ]),
//       ),
//     );
//   }
// }

class ListTileModel extends StatelessWidget {
  const ListTileModel({
    super.key,
    required this.patientname,
    required this.patientId,
    required this.viewonTap,
    required this.editonTap,
    required this.outvisitonTap,
    required this.invisitonTap,
  });

  final String patientname;
  final String patientId;
  final VoidCallback viewonTap;
  final VoidCallback editonTap;
  final VoidCallback outvisitonTap;
  final VoidCallback invisitonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12),bottom: Radius.circular(22)),
                        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ]
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PATIENT ID BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    patientId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            
                const SizedBox(height: 12),
            
                /// NAME
                const Text(
                  "NAME",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patientname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            
                const SizedBox(height: 16),
            
                /// STATUS
                Row(
                  children: [
                    const Text(
                      "STATUS",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 20),
            
                /// VIEW + EDIT
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: viewonTap,
                        icon: const Icon(Icons.remove_red_eye,
                            color:AppColors.primaryDark),
                        label:  const Text(
                          "View",
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: editonTap,
                        icon:
                            const Icon(Icons.edit, color: AppColors.primaryDark),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 14),
            
                /// OPD + IPD
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: outvisitonTap,
                          icon: const Icon(Icons.open_in_new,
                          color: Colors.white,),
                          label: const Text(
                            "OPD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                         decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: invisitonTap,
                          icon: const Icon(Icons.open_in_new,
                          color: Colors.white,),
                          label: const Text(
                            "IPD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
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


// class ViewModel extends StatelessWidget {
//   const ViewModel({
//     super.key,
//     required this.name,
//     required this.patientid,
//     required this.email,
//     required this.phonenumber,
//     required this.dob,
//     required this.age,
//     required this.gender,
//     required this.createdbydoctor,
//     required this.createdat,
//     required this.createdbyadmin,
//     required this.adminame, required this.doctoruserid, required this.adminuserid,
//   });

//   final String name;
//   final String patientid;
//   final String email;
//   final int phonenumber;
//   final String dob;
//   final String age;
//   final String gender;
//   final String createdbydoctor;
//   final String createdat;
//   final String createdbyadmin;
//   final String adminame;
//   final String doctoruserid;
//   final String adminuserid;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patient Details",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       context.router.pop();
//                     },
//                     icon: Icon(Icons.close))
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Name: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "${name}",
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//             if(email.isNotEmpty)
//             const SizedBox(
//               height: 8,
//             ),
//             if(email.isNotEmpty)
//             Row(
//               children: [
//                 const Text(
//                   "Email: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "${email}",
//                   style: TextStyle(fontSize: 14),
//                   overflow: TextOverflow.ellipsis,
//                 ),
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
//                 Text("${phonenumber}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "DOB: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${dob}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "PatientId: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("${patientid}", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Age: ",
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
//             if (createdbyadmin.isEmpty)
//               Row(
//                 children: [
//                   const Text(
//                     "Created By Doctor: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "${createdbydoctor}",
//                     style: TextStyle(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//               if (createdbyadmin.isEmpty)
//                const SizedBox(
//               height: 8,
//             ),
//               if (createdbyadmin.isEmpty)
//               Row(
//                 children: [
//                   const Text(
//                     "Doctor Userid: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "${doctoruserid}",
//                     style: TextStyle(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             //   if (createdbyadmin.isEmpty)
//             //   const SizedBox(
//             //   height: 8,
//             // ),
//             if (createdbyadmin.isNotEmpty)
//               Row(
//                 children: [
//                   const Text(
//                     "Created By Admin: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     adminame,
//                     style: TextStyle(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//               if (createdbyadmin.isNotEmpty)
//               const SizedBox(
//               height: 8,
//             ),
//               if (createdbyadmin.isNotEmpty)
//               Row(
//                 children: [
//                   const Text(
//                     "Admin Userid: ",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     adminuserid,
//                     style: TextStyle(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Creation Date: ",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text("$createdat", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ViewModel extends StatelessWidget {
  const ViewModel({
    super.key,
    required this.name,
    required this.patientid,
    required this.email,
    required this.phonenumber,
    required this.dob,
    required this.age,
    required this.gender,
    required this.createdbydoctor,
    required this.createdat,
    required this.createdbyadmin,
    required this.adminame,
    required this.doctoruserid,
    required this.adminuserid,
  });

  final String name;
  final String patientid;
  final String email;
  final int phonenumber;
  final String dob;
  final String age;
  final String gender;
  final String createdbydoctor;
  final String createdat;
  final String createdbyadmin;
  final String adminame;
  final String doctoruserid;
  final String adminuserid;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                           const SizedBox(width: 8),
                      const Text(
                        "Patient Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                        ],
                      ),
                      IconButton(
                      icon: const Icon(Icons.close, color: AppColors.primaryDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ],
                  ),
                 
                ],
              ),

              const SizedBox(height: 20),

              /// DETAILS
              _infoTile(Icons.badge, "PATIENT ID", patientid),
              _infoTile(Icons.person, "FULL NAME", name),
              if (email.isNotEmpty)
                _infoTile(Icons.email, "EMAIL ADDRESS", email),
              _infoTile(Icons.phone, "PHONE NUMBER", phonenumber.toString()),
              _infoTile(Icons.transgender, "GENDER", gender),
              _infoTile(Icons.cake, "DATE OF BIRTH", dob),
              _infoTile(Icons.calendar_today, "AGE", age),

              if (createdbyadmin.isEmpty) ...[
                _infoTile(Icons.medical_services, "CREATED BY DOCTOR",
                    createdbydoctor),
                _infoTile(
                    Icons.badge, "DOCTOR USERID", doctoruserid),
              ],

              if (createdbyadmin.isNotEmpty) ...[
                _infoTile(
                    Icons.admin_panel_settings,
                    "CREATED BY ADMIN",
                    adminame),
                _infoTile(
                    Icons.badge, "ADMIN USERID", adminuserid),
              ],

              _infoTile(Icons.access_time, "REGISTRATION DATE", createdat),
            ],
          ),
        ),
      ),
    );
  }

  /// SINGLE INFO ROW (matches image card rows)
  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
