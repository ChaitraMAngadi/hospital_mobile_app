import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/pdf.dart';




class ImportPdfViewerPage extends StatefulWidget {
  final String complaintId;
  final String patientId;

  const ImportPdfViewerPage({
    required this.complaintId,
    required this.patientId,
    Key? key,
  }) : super(key: key);

  @override
  State<ImportPdfViewerPage> createState() => _ImportPdfViewerPageState();
}

class _ImportPdfViewerPageState extends State<ImportPdfViewerPage> {
  String selectedLanguage = 'en'; // Default language
  bool isLoading = false;
  // bool isDownloading = false;
  Uint8List? pdfBytes;
  String? errorMessage;

  // Define available languages
  // final Map<String, String> languages = {
  //   'en': 'English',
  //   'hi': 'हिंदी',
  //   'ta': 'தமிழ்',
  //   'te': 'తెలుగు',
  //   'kn': 'ಕನ್ನಡ',
  //   'ml': 'മലയാളം',
  //   'bn': 'বাংলা',
  //   'gu': 'ગુજરાતી',
  //   'mr': 'मराठी',
  //   'pa': 'ਪੰਜਾਬੀ',
  // };

  @override
  void initState() {
    super.initState();
    _loadPdfData();
  }

  Future<void> _loadPdfData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final SecureStorage secureStorage = SecureStorage();
      Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
      print(Constants.doctortoken);
      
      final String url =
          "${Constants.baseUrl}/api/v1/hospitaldoctor/getallsharedpatientdownloadpdf/${widget.patientId}/${widget.complaintId}";
          print(url);

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.doctortoken}',
          // 'Accept-Language': selectedLanguage,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = Uint8List.fromList(response.bodyBytes);
         print(pdfBytes);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load PDF: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "An error occurred: $error";
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosis Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      
        elevation: 0,
       
      ),
      body: Column(
        children: [
          // PDF Viewer Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPdfViewer(),
              ),
            ),
          ),
          
        
        ],
      ),
    );
  }

  Widget _buildPdfViewer() {
    if (isLoading) {
      return _buildShimmerLoader();
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPdfData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (pdfBytes != null) {
      return PdfPreview(
        build: (format) => pdfBytes!,
        allowPrinting: false, // We handle printing separately
        allowSharing: false,  // We handle sharing separately
        canChangePageFormat: false,
        canDebug: false,
        previewPageMargin: EdgeInsets.all(0),
        initialPageFormat: PdfPageFormat.a4,

 maxPageWidth: MediaQuery.of(context).size.width,

        pdfFileName: "${widget.patientId}_Diagnosis_Report.pdf",
      );
    }

    return const Center(
      child: Text('No PDF data available'),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Shimmer Header (simulating PDF toolbar)
          Container(
            height: 60,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          
          // Shimmer PDF Pages
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Show 3 skeleton pages
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  height: 500,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header area
                      Container(
                        height: 80,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      
                      // Content lines
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(
                              8,
                              (lineIndex) => Container(
                                height: 16,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Footer area
                      Container(
                        height: 40,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Loading text with shimmer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 20,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}