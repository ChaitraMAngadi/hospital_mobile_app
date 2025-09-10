import 'package:flutter/material.dart';

class PatientDiagnosisDialog extends StatelessWidget {
  final Map<String, dynamic> diagnosisData;

  const PatientDiagnosisDialog({super.key, required this.diagnosisData});

  @override
  Widget build(BuildContext context) {
    final vitals = diagnosisData["vitals"] as List<dynamic>? ?? [];
    final medications = diagnosisData["medication"] as List<dynamic>? ?? [];

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Patient Diagnosis : ${diagnosisData["patientId"] ?? ""}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date
            Text(
              diagnosisData["createdAt"] ?? "",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Chief Complaint
            if (diagnosisData["complaint"] != null &&
                diagnosisData["complaint"].toString().isNotEmpty) ...[
              const Text("Chief Complaint",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(diagnosisData["complaint"]),
              const SizedBox(height: 16),
            ],

            // Vitals
            if (vitals.isNotEmpty) ...[
              const Text("Vitals",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: vitals.map((v) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(v["name"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(v["value"] ?? "",
                              style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Diagnosis Summary
            if (diagnosisData["diagnosis_summary"] != null) ...[
              const Text("Diagnosis Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(diagnosisData["diagnosis_summary"]),
              const SizedBox(height: 16),
            ],

            // Medical Advice
            if (diagnosisData["medical_advice"] != null) ...[
              const Text("Medical Advice",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(diagnosisData["medical_advice"]),
              const SizedBox(height: 16),
            ],

            // Lab Tests
            if (diagnosisData["lab_test"] != null) ...[
              const Text("Lab Tests",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(diagnosisData["lab_test"]),
              const SizedBox(height: 16),
            ],

            // Doctor's Remark
            if (diagnosisData["doctors_remark"] != null) ...[
              const Text("Doctor's Remark",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(diagnosisData["doctors_remark"]),
              const SizedBox(height: 16),
            ],

            // Medications
            if (medications.isNotEmpty) ...[
              const Text("Medication",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Column(
                children: medications.map((m) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(m["medicine"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        "${m["dosage"] ?? ""} - ${m["type"] ?? ""} (${m["timing"] ?? ""})"),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
