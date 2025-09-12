import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditComplaintDialogBox extends StatefulWidget {
  final List<Map<String, dynamic>> alldoctors;
  final List<Map<String, dynamic>> allnurses;
  final String patientId;
  final String complaintId; 


  const EditComplaintDialogBox({
    super.key,
    required this.alldoctors,
    required this.allnurses,
    required this.patientId, required this.complaintId,
    
  });

  @override
  State<EditComplaintDialogBox> createState() => _EditComplaintDialogBoxState();
}

class _EditComplaintDialogBoxState extends State<EditComplaintDialogBox> {
    late Future fetchvisit;
   TextEditingController complaintController = TextEditingController();

  Map<String, dynamic>? selectedDutyDoctor;
  Map<String, dynamic>? selectedVisitingDoctor;
  Map<String, dynamic>? selectedConsultingDoctor;
  Map<String, dynamic>? selectedNurse;

  final formkey = GlobalKey<FormState>();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();

     Adminprovider adminprovider =
        context.read<Adminprovider>();
    fetchvisit = adminprovider.getinvisitbyid(widget.patientId, widget.complaintId).then((_) {
      if (adminprovider.complaintdetails.isNotEmpty) {
        final data = adminprovider.complaintdetails.first;
        complaintController.text =data['chief_complaint'] ?? "";
        selectedConsultingDoctor = data['consultingDoctor']??'';
        selectedDutyDoctor = data['dutyDoctor']??'';
    selectedVisitingDoctor = data['visitingDoctor']??'';
    selectedNurse = data['associatedNurse']??'';
      }
    });

  }

    Widget _buildShimmerSkeleton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Email field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Phone field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // DOB field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Gender field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Age field shimmer
            _buildShimmerField(),
            const SizedBox(height: 32),
            
            // Button shimmer
            _buildShimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label shimmer
        Container(
          height: 16,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        // Field shimmer
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[200]!),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Adminprovider adminprovider = context.read<Adminprovider>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<Adminprovider>(
        builder:(context, adminprovider, child) {
        return FutureBuilder(future: fetchvisit, builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerSkeleton();
          // const Padding(
          //   padding: EdgeInsets.all(20),
          //   child: Center(child: CircularProgressIndicator()),
          // );
        }

          return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Complaint Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                /// Visit Date
                Text(
                  "Visit Date: $formattedDate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                /// Chief complaint
                const Text("Chief complaint *",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  readOnly: true,
                  controller: complaintController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter chief complaint';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Chief complaint",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Consulting Doctor
                const Text("Consulting Doctor*",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.alldoctors,
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedConsultingDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  validator: (value) =>
                      value == null ? "Please select a Consulting Doctor" : null,
                  onChanged: (value) {
                    setState(() {
                      selectedConsultingDoctor = value;
                      if (selectedDutyDoctor?['userid'] ==
                          selectedConsultingDoctor?['userid']) {
                        selectedDutyDoctor = null;
                      }
                      if (selectedVisitingDoctor?['userid'] ==
                          selectedConsultingDoctor?['userid']) {
                        selectedVisitingDoctor = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),

                /// Duty Doctor
                const Text("Duty Doctor",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.alldoctors
                      .where((doc) =>
                          doc['userid'] != selectedConsultingDoctor?['userid'])
                      .toList(),
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedDutyDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  onChanged: (value) {
                    setState(() {
                      selectedDutyDoctor = value;
                      if (selectedVisitingDoctor?['userid'] ==
                          selectedDutyDoctor?['userid']) {
                        selectedVisitingDoctor = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),

                /// Visiting Doctor
                const Text("Visiting Doctor",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.alldoctors
                      .where((doc) =>
                          doc['userid'] != selectedDutyDoctor?['userid'] &&
                          doc['userid'] != selectedConsultingDoctor?['userid'])
                      .toList(),
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedVisitingDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  onChanged: (value) {
                    if (value?['userid'] == selectedDutyDoctor?['userid'] ||
                        value?['userid'] ==
                            selectedConsultingDoctor?['userid']) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Visiting doctor cannot be the same as Duty or Consulting doctor")));
                      return;
                    }
                    setState(() {
                      selectedVisitingDoctor = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                /// Associated Nurse
                const Text("Associated Nurse",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.allnurses,
                  itemAsString: (nurse) =>
                      "${nurse['name']} | ${nurse['userid']}",
                  selectedItem: selectedNurse,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  onChanged: (value) {
                    setState(() {
                      selectedNurse = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                /// Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: adminprovider.updatinginvisit
                        ? null
                        : () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                adminprovider.updatinginvisit = true;
                              });

                              adminprovider.editinvisit(
                                widget.patientId,
                                widget.complaintId,
                                selectedConsultingDoctor?['userid'] ?? '',
                                selectedVisitingDoctor?['userid'] ?? '',
                                selectedDutyDoctor?['userid'] ?? '',
                                selectedNurse?['userid'] ?? '',
                                context,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: adminprovider.updatinginvisit
                          ? Colors.grey.shade300
                          : const Color(0xFF0857C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    child: const Text("Update",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      );
        },);
      },),
    );
  }
}
