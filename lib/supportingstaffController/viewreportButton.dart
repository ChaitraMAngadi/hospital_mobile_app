import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/supportingstaffController/viewReportPdfViewerPage.dart';

class ViewreportInvisitPdfButton extends StatelessWidget {
  final String patientId;
  final String complaintId;
  final String diagnosisId;

  const ViewreportInvisitPdfButton({
    required this.patientId,
     required this.complaintId,
    required this.diagnosisId,
    Key? key,
  }) : super(key: key);

  Future<void> _downloadAndPrintPdf(BuildContext context) async {
    // final SecureStorage secureStorage = SecureStorage();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        backgroundColor: WidgetStatePropertyAll(Color(0XFF0857C0)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      // onPressed: () {
        
      // },
      onPressed: () =>
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewreportPdfViewerPage(
              complaintId: complaintId,
              patientId: patientId, 
              diagnosisId: diagnosisId,
            ),
          ),
        ),
          // _downloadAndPrintPdf(context), // Directly show printing layout
      child: const Text(
        "View Report",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
