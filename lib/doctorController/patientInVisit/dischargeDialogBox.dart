import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DischargeDialogBox extends StatefulWidget {
  final String patientId;
  final String complaintId;
  const DischargeDialogBox({super.key, required this.patientId, required this.complaintId});

  @override
  State<DischargeDialogBox> createState() => _DischargeDialogBoxState();
}

class _DischargeDialogBoxState extends State<DischargeDialogBox> {

  
  final TextEditingController dischargesummaryController = TextEditingController();
  final formkey = GlobalKey<FormState>();
    final TextEditingController dateController = TextEditingController();


  String formatedJoiDate = "";

    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  


  @override
  Widget build(BuildContext context) {
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    return Dialog(
                                           insetPadding:
                                              const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                                  child: SingleChildScrollView(
                                                    padding: EdgeInsets.all(16),
                                                    child: Form(
                                                      key: formkey,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Discharge Inpatient",
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
                  height: 16,
                ),

                /// Visit Date
                Text(
                  "Discharge Date: $formattedDate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                /// Chief complaint
                const Text("Discharge Summary *",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: dischargesummaryController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Discharge Summary';
                    }
                    return null; // Return null if validation is successful
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Discharge Summary",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                 SizedBox(height: 8,),
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
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                      print(dischargesummaryController.text);
                      await doctorprovider.dischargeInPatient(widget.patientId, widget.complaintId, dischargesummaryController.text,formatedJoiDate, context);

                      await doctorprovider.getpatientinvisits(widget.patientId);
                      
                      }

                      // context.router.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0857C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: Text("Discharge Inpatient",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                )

                                                      ],
                                                    )),
                                                  ),
                                          
                                        );
  }
}