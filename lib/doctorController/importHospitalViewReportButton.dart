import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/importHospitalPdfViewerPage.dart';
import 'package:hospital_mobile_app/doctorController/importPdfViewerPage.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';


class ImportPdfButton extends StatelessWidget {
  final String complaintId;
  final String patientId;
  final bool ispatient;


  const ImportPdfButton({
    required this.complaintId,
    required this.patientId,
    required this.ispatient,

    Key? key, 
  }) : super(key: key);

  Future<void> _downloadAndPrintPdf(BuildContext context) async {
    final SecureStorage secureStorage = SecureStorage();

    // Show loading dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return const AlertDialog(
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           CircularProgressIndicator(),
    //           SizedBox(height: 16),
    //           Text("Downloading PDF..."),
    //         ],
    //       ),
    //     );
    //   },
    // );

    // try {
    //   Constants.token = await secureStorage.readSecureData('token') ?? '';
    //   final String url =
    //       "${Constants.baseUrl}/api/v1/doctor/getdownloaddetailspdf/$patientId/$complaintId";

    //   final response = await http.get(
    //     Uri.parse(url),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer ${Constants.token}',
    //     },
    //   );

    //   if (response.statusCode == 200) {
    //     Uint8List pdfBytes = Uint8List.fromList(response.bodyBytes);

    //     // Close the loading dialog before opening the print preview
    //     Navigator.pop(context);

    //     // Open the printing layout directly
    //     await Printing.layoutPdf(
    //       onLayout: (PdfPageFormat format) async => pdfBytes,
    //       name: "${patientId}_Report.pdf",
    //     );
    //   } else {
    //     Navigator.pop(context); // Close loading dialog
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content:
    //             Text("Failed to download the report: ${response.statusCode}"),
    //       ),
    //     );
    //   }
    // } catch (error) {
    //   Navigator.pop(context); // Close loading dialog
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("An error occurred: $error")),
    //   );
    // }
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
      onPressed: () =>!ispatient ?
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportHospitalPdfViewerPage(
              complaintId: complaintId,
              patientId: patientId,
            ),
          ),
        ):Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportPdfViewerPage(
              complaintId: complaintId,
              patientId: patientId,
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
