import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/supportingstaffProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AddObservationPage extends StatefulWidget {
  const AddObservationPage({
    super.key,
    required this.patientId,
    required this.complaintId, required this.visitIndex,

  });

  final String patientId;
  final String complaintId;
  final int visitIndex;

  @override
  State<AddObservationPage> createState() => _AddObservationPageState();
}

class _AddObservationPageState extends State<AddObservationPage> {
  
  List<VitalControllers> vitalsControllersList = [];



   final TextEditingController _summaryController = TextEditingController();
   bool allMedicinesTaken = false;

  final formkey = GlobalKey<FormState>();

  final GlobalKey complaintFieldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    vitalsControllersList.add(VitalControllers());
  }

  void addVital() {
  setState(() {
    vitalsControllersList.add(VitalControllers());
  });
}


  String formatJoiDate(String pickedDate) {
    final parsedDate = DateTime.parse(pickedDate);
    final formattedJoiDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedJoiDate;
  }


  

  @override
  void dispose() {
     for (var controllers in vitalsControllersList) {
    controllers.dispose();
  }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Supportingstaffprovider supportingstaffprovider = context.read<Supportingstaffprovider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Observation',
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
                "Observation Summary*",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: complaintFieldKey,
                controller: _summaryController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter observation summary';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter observation summary',
                ),
              ),
              
              const SizedBox(height: 12),
              
const Text(
  "Vitals",
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 6),

...vitalsControllersList.asMap().entries.map((entry) {
  // final index = entry.key;
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

 Row(
                children: [
                  Checkbox(
                    value: allMedicinesTaken,
                    onChanged: (val) {
                      setState(() {
                        allMedicinesTaken = val ?? false;
                      });
                    },
                  ),
                  const Text("All Medicines are taken on time"),
                ],
              ),

const SizedBox(height: 24),

              
              // Updated medication field sets with autocomplete


              
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:supportingstaffprovider.addingobservation ? null : () async {

                   
                                
                    if (!formkey.currentState!.validate()) {
                       
                      if (_summaryController.text.isEmpty) {
                        Scrollable.ensureVisible(
                          complaintFieldKey.currentContext!,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                      return;
                    }

                    List<Map<String, dynamic>> vitalsList = vitalsControllersList
    .where((controllers) => controllers.nameController.text.trim().isNotEmpty)
    .map((controllers) {
  return {
    'name': controllers.nameController.text,
    'value': controllers.valueController.text,
  };
}).toList();

print(vitalsList);

 setState(() {
                                  supportingstaffprovider.addingobservation = true;
                                });
                    await supportingstaffprovider.addobservation(
                        widget.patientId,
                        widget.complaintId,
                        widget.visitIndex,
                        _summaryController.text,
                        vitalsList,
                       allMedicinesTaken,
                        context);

                    // doctorprovider todaysvisitprovider = context.read<Todayvisitprovider>();
                    await supportingstaffprovider.getpatientobservations(widget.patientId,widget.visitIndex);
                    supportingstaffprovider.notify();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: supportingstaffprovider.addingobservation ? Colors.grey :Color(0xFF0857C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child:
                  supportingstaffprovider.addingobservation ? const CircularProgressIndicator():
                   const Text("Add Observation",
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


class VitalControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}

class VitalsFieldSet extends StatefulWidget {
  final VitalControllers controllers;

  const VitalsFieldSet({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  State<VitalsFieldSet> createState() => _VitalsFieldSetState();
}

class _VitalsFieldSetState extends State<VitalsFieldSet> {
  bool isValueEnabled = false;

 @override
  void initState() {
    super.initState();
    // Listen to changes in name field
    widget.controllers.nameController.addListener(_checkNameField);
  }

   void _checkNameField() {
    final isNotEmpty = widget.controllers.nameController.text.trim().isNotEmpty;
    if (isNotEmpty != isValueEnabled) {
      setState(() {
        isValueEnabled = isNotEmpty;
      });
    }
  }

    @override
  void dispose() {
    widget.controllers.nameController.removeListener(_checkNameField);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controllers.nameController,
              decoration: const InputDecoration(
                hintText: 'Name (e.g. Temperature)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controllers.valueController,
              enabled: isValueEnabled,
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


