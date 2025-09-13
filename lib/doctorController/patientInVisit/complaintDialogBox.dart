import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComplaintDialog extends StatefulWidget {
  final List<Map<String, dynamic>> alldoctors;
  final List<Map<String, dynamic>> allnurses;
  final String patientId;

  const ComplaintDialog({
    super.key,
    required this.alldoctors,
    required this.allnurses,
    required this.patientId,
  });

  @override
  State<ComplaintDialog> createState() => _ComplaintDialogState();
}

class _ComplaintDialogState extends State<ComplaintDialog> {
  final TextEditingController complaintController = TextEditingController();

  Map<String, dynamic>? selectedDutyDoctor;
  Map<String, dynamic>? selectedVisitingDoctor;
  Map<String, dynamic>? selectedNurse;

  final formkey = GlobalKey<FormState>();

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
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
                        icon: const Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

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
                      return 'Please enter cheif complaint';
                    }
                    return null; // Return null if validation is successful
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Chief complaint",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Duty Doctor
                const Text("Duty Doctor",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownSearch<Map<String, dynamic>>(
                  items: widget.alldoctors,
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedDutyDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Duty Doctor",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12), // rounded corners
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                  //         validator: (value) {
                  //   if (value == null) {
                  //     return "Please select a Duty Doctor";
                  //   }
                  //   return null;
                  // },
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
                          doc['userid'] != selectedDutyDoctor?['userid'])
                      .toList(),
                  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                  selectedItem: selectedVisitingDoctor,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Visiting Doctor",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12), // rounded corners
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                  //         validator: (value) {
                  //   if (value == null) {
                  //     return "Please select a Visiting Doctor";
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    if (value?['userid'] == selectedDutyDoctor?['userid']) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Visiting doctor cannot be the same as duty doctor")));
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

                  popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select Nurse",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12), // rounded corners
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0857C0)),
                      ),
                    ),
                  ),
                  //         validator: (value) {
                  //   if (value == null) {
                  //     return "Please select a Supporting staff";
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    setState(() {
                      selectedNurse = value;
                    });
                    debugPrint("Nurse ID: ${value?['userid']}");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:doctorprovider.addinginvisit? null: () async {

                      if (formkey.currentState!.validate()) {
                         setState(() {
                                  doctorprovider.addinginvisit = true;
                                });
                        debugPrint("Complaint: ${complaintController.text}");
                        debugPrint(
                            "Duty Doctor ID: ${selectedDutyDoctor?['userid']}");
                        debugPrint(
                            "Visiting Doctor ID: ${selectedVisitingDoctor?['userid']}");
                        debugPrint("Nurse ID: ${selectedNurse?['userid']}");

                        doctorprovider.addinvisit(
                          widget.patientId,
                          complaintController.text,
                          selectedVisitingDoctor?['userid']??'',
                          selectedDutyDoctor?['userid']??'',
                          selectedNurse?['userid']??'',
                          context,
                        );
                      }

                      // context.router.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:doctorprovider.addinginvisit? Colors.grey: Color(0xFF0857C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child:
                    doctorprovider.addinginvisit? CircularProgressIndicator():
                     Text("Submit",
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
