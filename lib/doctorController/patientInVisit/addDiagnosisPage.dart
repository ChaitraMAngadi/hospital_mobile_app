import 'dart:convert';
import 'dart:io';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:http/http.dart' as http;
import 'package:auto_route/auto_route.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AddDiagnosisPage extends StatefulWidget {
  const AddDiagnosisPage({
    super.key,
    required this.patientId,
    required this.complaintId, required this.visitIndex,

  });

  final String patientId;
  final String complaintId;
  final int visitIndex;

  @override
  State<AddDiagnosisPage> createState() => _AddDiagnosisPageState();
}

class _AddDiagnosisPageState extends State<AddDiagnosisPage> {
  List<MedicationFieldSet> medicationFieldSets = [];
  List<MedicationControllers> medicationControllersList = [];
  String formatedJoiDate = "";

  List<VitalControllers> vitalsControllersList = [];



  final TextEditingController complaintController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController medicaladviceController = TextEditingController();
  final TextEditingController labtestController = TextEditingController();
  final TextEditingController doctorremarkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  final GlobalKey complaintFieldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    medicationControllersList.add(MedicationControllers());
    vitalsControllersList.add(VitalControllers());
  }

  void addVital() {
  setState(() {
    vitalsControllersList.add(VitalControllers());
  });
}

  void addMedication() {
    setState(() {
      medicationControllersList.add(MedicationControllers());
    });
  }

  String formatJoiDate(String pickedDate) {
    final parsedDate = DateTime.parse(pickedDate);
    final formattedJoiDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedJoiDate;
  }

  List<File> selectedFiles = [];

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
      print("Selected ${selectedFiles.length} files");
    } else {
      print("No files selected");
    }
  }

  @override
  void dispose() {
    for (var controllers in medicationControllersList) {
      controllers.dispose();
    }
     for (var controllers in vitalsControllersList) {
    controllers.dispose();
  }
    super.dispose();
  }

  // Future<List<Map<String, dynamic>>> fetchMedicineSuggestions(String query) async {
  //   if (query.isEmpty) return [];
    
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${Constants.baseUrl}/api/v1/doctor/suggestion-medicine?search=$query',
        
  //       ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Constants.token}',
  //       },
  //     );
      
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       print(data);
  //       if (data['success'] == true && data['medicines'] != null) {
  //         return List<Map<String, dynamic>>.from(data['medicines']);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching medicine suggestions: $e');
  //   }
    
  //   return [];
  // }

  @override
  Widget build(BuildContext context) {
    final allPaths = selectedFiles.map((file) => file.path.split('/').last).join(', ');

    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Diagnosis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text(
                "Complaint*",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: complaintFieldKey,
                controller: complaintController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Complaint';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Complaint',
                ),
              ),
              SizedBox(height: 12,),
              const Text(
                "Diagnosis",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
               
                controller: diagnosisController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Diagnosis';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Diagnosis',
                ),
              ),
              const SizedBox(height: 12),
              
const Text(
  "Vitals",
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 6),

...vitalsControllersList.asMap().entries.map((entry) {
  final index = entry.key;
  final controllers = entry.value;
  return VitalsFieldSet(
    controllers: controllers,
  );
}).toList(),

const SizedBox(height: 6),
ElevatedButton(
  onPressed: addVital,
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF0857C0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
  child: const Text(
    "Add Vital",
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
),

const SizedBox(height: 12),

              
              // Updated medication field sets with autocomplete
              ...medicationControllersList
                  .map((controllers) => MedicationFieldSet(
                        controllers: controllers,
                        // fetchMedicineSuggestions: fetchMedicineSuggestions,
                      ))
                  .toList(),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: addMedication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0857C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text("Add Medication",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
              
              // ... rest of your form fields remain the same
              const SizedBox(height: 12),
              const Text(
                "Medical Advice",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: medicaladviceController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Medical Advice',
                ),
              ),
              const SizedBox(height: 12),
              
              const Text(
                "Lab Tests",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: labtestController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Lab Tests',
                ),
              ),
              const SizedBox(height: 12),
              
              const Text(
                "Supporting Files",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: pickFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0857C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text(
                  'Pick Files',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              if (selectedFiles.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(selectedFiles.length, (index) {
                    final file = selectedFiles[index];
                    final extension = file.path.split('.').last.toLowerCase();
                    final isImage = ['jpg', 'jpeg', 'png'].contains(extension);

                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.insert_drive_file,
                                        size: 40, color: Colors.blue),
                                    const SizedBox(height: 5),
                                    Text(
                                      file.path.split('/').last,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFiles.removeAt(index);
                            });
                          },
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

              if (selectedFiles.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No files selected',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              const SizedBox(height: 12),
              
              const Text(
                "Next Visit Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                        onTap: () async {
                          DateTime today = DateTime.now();
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: today,
                            firstDate: today,
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                            dateController.text = formattedDate;
                            formatedJoiDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        child: const Icon(Icons.calendar_month_outlined)),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: 'dd/MM/yyyy',
                ),
              ),
              const SizedBox(height: 12),
              
              const Text(
                "Doctors remark",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: doctorremarkController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Doctors remark',
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:doctorprovider.isSavingIndiagnosis ? null : () async {

                     setState(() {
                                  doctorprovider.isSavingIndiagnosis = true;
                                });
                                
                    if (!formkey.currentState!.validate()) {
                      if (diagnosisController.text.isEmpty) {
                        Scrollable.ensureVisible(
                          complaintFieldKey.currentContext!,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                      return;
                    }

                    List<Map<String, dynamic>> medicationList = medicationControllersList
                        .where((controllers) => controllers.medicineController.text.trim().isNotEmpty)
                        .map((controllers) {
                      return {
                        'medicine': controllers.medicineController.text,
                        'type': controllers.typeController.text,
                        'food': controllers.foodOptionController.text,
                        'time': controllers.selectedTimes,
                        'power': controllers.powerController.text,
                        'count': controllers.countController.text,
                        'duration': controllers.durationController.text,
                        'special_instruction': controllers.specialInstructionController.text,
                      };
                    }).toList();

                    List<Map<String, dynamic>> vitalsList = vitalsControllersList
    .where((controllers) => controllers.nameController.text.trim().isNotEmpty)
    .map((controllers) {
  return {
    'name': controllers.nameController.text,
    'value': controllers.valueController.text,
  };
}).toList();

print(vitalsList);
                    await doctorprovider.addinpatientdiagnosis(
                        widget.patientId,
                        widget.complaintId,
                        widget.visitIndex,
                        complaintController.text,
                        diagnosisController.text,
                        medicaladviceController.text,
                        labtestController.text,
                        doctorremarkController.text,
                        formatedJoiDate,
                        vitalsList,
                        medicationList,
                        
                        selectedFiles,
                        context);

                    // doctorprovider todaysvisitprovider = context.read<Todayvisitprovider>();
                    await doctorprovider.getpatientdiagnosis(widget.patientId,widget.visitIndex);
                    doctorprovider.notify();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: doctorprovider.isSavingIndiagnosis ? Colors.grey :Color(0xFF0857C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child:
                  doctorprovider.isSavingIndiagnosis ? const CircularProgressIndicator():
                   const Text("Save Report",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MedicationControllers {
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController foodOptionController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController specialInstructionController = TextEditingController();

  List<String> selectedTimes = [];

  void dispose() {
    medicineController.dispose();
    typeController.dispose();
    foodOptionController.dispose();
    powerController.dispose();
    countController.dispose();
    durationController.dispose();
    specialInstructionController.dispose();
  }
}

class MedicationFieldSet extends StatefulWidget {
  final MedicationControllers controllers;
  // final Future<List<Map<String, dynamic>>> Function(String) fetchMedicineSuggestions;

  const MedicationFieldSet({
    required this.controllers,
    // required this.fetchMedicineSuggestions,
  });

  @override
  State<MedicationFieldSet> createState() => _MedicationFieldSetState();
}

class _MedicationFieldSetState extends State<MedicationFieldSet> {
  bool isMedicationNameAdded = false;
  List<Map<String, dynamic>> suggestions = [];
  bool showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  bool _isSelecting = false; // Flag to prevent showing suggestions during selection
  
  @override
  void initState() {
    super.initState();
    widget.controllers.medicineController.addListener(_onMedicineTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controllers.medicineController.removeListener(_onMedicineTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }
  
  void _onMedicineTextChanged() async {
    // Don't show suggestions if we're in the middle of selecting
    if (_isSelecting) {
      return;
    }

    final query = widget.controllers.medicineController.text;
    
    setState(() {
      isMedicationNameAdded = query.isNotEmpty;
    });

    // if (query.length >= 1) {
    //   final fetchedSuggestions = await widget.fetchMedicineSuggestions(query);
    //   setState(() {
    //     suggestions = fetchedSuggestions;
        
    //   });
      
    //   if (fetchedSuggestions.isNotEmpty && _focusNode.hasFocus) {
    //     _showOverlay();
    //   } else {
    //     _removeOverlay();
    //   }
    // } else {
    //   setState(() {
    //     suggestions = [];
    //   });
    //   _removeOverlay();
    // }
  }

  void _showOverlay() {
    _removeOverlay(); // Remove existing overlay first
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // Adjust this offset as needed
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return InkWell(
                    onTap: () => _selectSuggestion(suggestion['name'] ?? ''),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        suggestion['name'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectSuggestion(String medicineName) {
    _isSelecting = true; // Set flag to prevent suggestions
    
    widget.controllers.medicineController.text = medicineName;
    _removeOverlay();
    setState(() {
      isMedicationNameAdded = true;
    });
    
    // Move cursor to end of text
    widget.controllers.medicineController.selection = TextSelection.fromPosition(
      TextPosition(offset: medicineName.length),
    );
    
    // Reset the flag after a short delay to allow normal typing again
    Future.delayed(const Duration(milliseconds: 300), () {
      _isSelecting = false;
    });

    print(_isSelecting);
  }

  double _getTextFieldWidth() {
    // Calculate the width of the text field
    // You might need to adjust this based on your layout
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - 32 - 10) / 2; // Considering padding and spacing
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medication',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: widget.controllers.medicineController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Medicine',
                    border: OutlineInputBorder(),
                  ),
                  // onTap: () {
                  //   print('_isSelecting ${_isSelecting}');
                  //   // Only show overlay if not selecting and has suggestions
                  //   if (suggestions.isNotEmpty && !_isSelecting) {
                  //     _showOverlay();
                  //   }
                  // },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Tablet",
                  "Ointment",
                  "Injection",
                  "IV",
                  "Supporter",
                  "Drops",
                  "Bandage",
                  "Syrup",
                  "Others",
                ]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: isMedicationNameAdded
                    ? (value) {
                        widget.controllers.typeController.text = value!;
                      }
                    : null,
                onSaved: (newValue) {
                  widget.controllers.typeController.text = newValue!;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controllers.powerController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Power',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controllers.countController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Count',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabled: isMedicationNameAdded,
            hintText: 'Select Food option',
            border: OutlineInputBorder(),
          ),
          items: ["Before food", "After Food", "NA"]
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: isMedicationNameAdded
              ? (value) {
                  widget.controllers.foodOptionController.text = value!;
                }
              : null,
          onSaved: (newValue) {
            widget.controllers.foodOptionController.text = newValue!;
          },
        ),
       
        const SizedBox(height: 10),
        GestureDetector(
          onTap: isMedicationNameAdded
              ? () async {
                  final List<String> options = [
                    "Morning",
                    "AfterNoon",
                    "Evening",
                    "Night"
                  ];
                  final selected = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      List<String> tempSelected = List.from(widget.controllers.selectedTimes);

                      return Dialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Select Times for Medicine',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: options.map((option) {
                                        final bool isSelected = tempSelected.contains(option);
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                tempSelected.remove(option);
                                              } else {
                                                tempSelected.add(option);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(vertical: 6),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Color(0xFF0857C0)
                                                  : Colors.grey[200],
                                            ),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, tempSelected);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xFF0857C0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (selected != null) {
                    setState(() {
                      widget.controllers.selectedTimes = selected;
                    });
                  }
                }
              : () {},
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: isMedicationNameAdded
                  ? Border.all(color: Colors.grey)
                  : Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.controllers.selectedTimes.isEmpty
                        ? 'Select time for taking medicine'
                        : widget.controllers.selectedTimes.join(', '),
                    style: TextStyle(
                        fontSize: 16,
                        color: isMedicationNameAdded ? Colors.black : Colors.grey),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isMedicationNameAdded ? Colors.black : Colors.grey,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controllers.durationController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Duration in days',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controllers.specialInstructionController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Special Instruction',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VitalControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}

class VitalsFieldSet extends StatelessWidget {
  final VitalControllers controllers;

  const VitalsFieldSet({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllers.nameController,
              decoration: const InputDecoration(
                hintText: 'Name (e.g. Temperature)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controllers.valueController,
              decoration: const InputDecoration(
                hintText: 'Value (e.g. 101°F)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


