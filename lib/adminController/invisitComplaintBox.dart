import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComplaintDialogBox extends StatefulWidget {
  final List<Map<String, dynamic>> alldoctors;
  final List<Map<String, dynamic>> allnurses;
  final String patientId;

  const ComplaintDialogBox({
    super.key,
    required this.alldoctors,
    required this.allnurses,
    required this.patientId,
  });

  @override
  State<ComplaintDialogBox> createState() => _ComplaintDialogBoxState();
}

class _ComplaintDialogBoxState extends State<ComplaintDialogBox> {
  final TextEditingController complaintController = TextEditingController();

  Map<String, dynamic>? selectedDutyDoctor;
  Map<String, dynamic>? selectedVisitingDoctor;
  Map<String, dynamic>? selectedConsultingDoctor;
  Map<String, dynamic>? selectedNurse;

  final formkey = GlobalKey<FormState>();

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Adminprovider adminprovider = context.read<Adminprovider>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
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
                      "Enter Complaint Details",
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
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: false,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            widget.alldoctors.length), // limit size
                    fit: FlexFit.loose, // don’t stretch
                  ),
                  // popupProps: const PopupProps.menu(showSearchBox: true),
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

                      // Reset duty doctor if same as consulting doctor
                      if (selectedDutyDoctor?['userid'] ==
                          selectedConsultingDoctor?['userid']) {
                        selectedDutyDoctor = null;
                      }

                      // Reset visiting doctor if same as consulting doctor
                      if (selectedVisitingDoctor?['userid'] ==
                          selectedConsultingDoctor?['userid']) {
                        selectedVisitingDoctor = null;
                      }
                    });
                    debugPrint("Consulting Doctor ID: ${value?['userid']}");
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
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: false,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            widget.alldoctors.length), // limit size
                    fit: FlexFit.loose, // don’t stretch
                  ),
                  // popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Duty Doctor",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedDutyDoctor = value;

                      // Reset visiting doctor if same as duty doctor
                      if (selectedVisitingDoctor?['userid'] ==
                          selectedDutyDoctor?['userid']) {
                        selectedVisitingDoctor = null;
                      }
                    });
                    debugPrint("Duty Doctor ID: ${value?['userid']}");
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
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: false,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            widget.alldoctors.length), // limit size
                    fit: FlexFit.loose, // don’t stretch
                  ),
                  // popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Visiting Doctor",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
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
                    debugPrint("Visiting Doctor ID: ${value?['userid']}");
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
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: false,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            widget.alldoctors.length), // limit size
                    fit: FlexFit.loose, // don’t stretch
                  ),
                  // popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Nurse",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedNurse = value;
                    });
                    debugPrint("Nurse ID: ${value?['userid']}");
                  },
                ),
                const SizedBox(height: 20),

                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: adminprovider.addinginvisit
                        ? null
                        : () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                adminprovider.addinginvisit = true;
                              });
                              debugPrint(
                                  "Complaint: ${complaintController.text}");
                              debugPrint(
                                  "Consulting Doctor ID: ${selectedConsultingDoctor?['userid']}");
                              debugPrint(
                                  "Duty Doctor ID: ${selectedDutyDoctor?['userid']}");
                              debugPrint(
                                  "Visiting Doctor ID: ${selectedVisitingDoctor?['userid']}");
                              debugPrint(
                                  "Nurse ID: ${selectedNurse?['userid']}");

                              adminprovider.addinvisit(
                                widget.patientId,
                                complaintController.text,
                                selectedConsultingDoctor?['userid'] ?? '',
                                selectedVisitingDoctor?['userid'] ?? '',
                                selectedDutyDoctor?['userid'] ?? '',
                                selectedNurse?['userid'] ?? '',
                                context,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: adminprovider.addinginvisit
                          ? Colors.grey.shade300
                          : const Color(0xFF0857C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    child: const Text("Submit",
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
      ),
    );
  }
}
