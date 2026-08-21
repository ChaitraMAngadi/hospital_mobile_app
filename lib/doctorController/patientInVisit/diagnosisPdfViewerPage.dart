// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:hospital_mobile_app/service/constant.dart';
// import 'package:hospital_mobile_app/service/secure_storage.dart';
// import 'package:hospital_mobile_app/theme/app_colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:printing/printing.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:pdf/pdf.dart';




// class DiagnosisPdfViewerPage extends StatefulWidget {
//   final String complaintId;
//   final String patientId;
//   final String diagnosisId;

//   const DiagnosisPdfViewerPage({
//     required this.complaintId,
//     required this.patientId,
//      required this.diagnosisId,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<DiagnosisPdfViewerPage> createState() => _DiagnosisPdfViewerPageState();
// }

// class _DiagnosisPdfViewerPageState extends State<DiagnosisPdfViewerPage> {
//   String selectedLanguage = 'en'; // Default language
//   bool isLoading = false;
//   bool isDownloading = false;
//   Uint8List? pdfBytes;
//   String? errorMessage;

//   // Define available languages
//   final Map<String, String> languages = {
//     'en': 'English',
//     'hi': 'हिंदी',
//     'ta': 'தமிழ்',
//     'te': 'తెలుగు',
//     'kn': 'ಕನ್ನಡ',
//     'ml': 'മലയാളം',
//     'bn': 'বাংলা',
//     'gu': 'ગુજરાતી',
//     'mr': 'मराठी',
//     'pa': 'ਪੰਜਾਬੀ',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadPdfData();
//   }

  // Future<void> _loadPdfData() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = null;
  //   });

  //   try {
  //     final SecureStorage secureStorage = SecureStorage();
  //     Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
      
  //     final String url =
  //         "${Constants.baseUrl}/api/v1/hospitaldoctor/getindownloaddetailspdf/${widget.patientId}/${widget.complaintId}/${widget.diagnosisId}/$selectedLanguage";
  //         print(url);

  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Constants.doctortoken}',
  //         // 'Accept-Language': selectedLanguage,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         pdfBytes = Uint8List.fromList(response.bodyBytes);
  //        print(pdfBytes);
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = "Failed to load PDF: ${response.statusCode}";
  //         isLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     setState(() {
  //       errorMessage = "An error occurred: $error";
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _downloadAndPrintPdf() async {
  //   if (pdfBytes == null) return;

  //   setState(() {
  //     isDownloading = true;
  //   });

  //   try {
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdfBytes!,
  //       name: "${widget.patientId}_Diagnosis_Report_${languages[selectedLanguage]}.pdf",
  //     );
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to print/download: $error")),
  //     );
  //   } finally {
  //     setState(() {
  //       isDownloading = false;
  //     });
  //   }
  // }

  // void _onLanguageChanged(String? newLanguage) {
  //   if (newLanguage != null && newLanguage != selectedLanguage) {
  //     setState(() {
  //       selectedLanguage = newLanguage;
  //     });
  //     _loadPdfData(); // Reload PDF with new language
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: AppColors.primaryGradient,
//           ),
//         ),
//         title: const Text(
//           'Diagnosis Report',
//           style: TextStyle(fontWeight: FontWeight.bold,
//           color: Colors.white),
//         ),
//         leading: IconButton(onPressed: (){
//           Navigator.pop(context);
//         }, icon:Icon( Icons.arrow_back,
//         color: Colors.white,),
//         ),
//         // backgroundColor: const Color(0XFF0857C0),
//         // foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           // Language Dropdown in AppBar
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: selectedLanguage,
//                 icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//                 style: const TextStyle(color: Colors.white, fontSize: 14),
//                 dropdownColor: AppColors.secondary,
//                 onChanged: _onLanguageChanged,
//                 items: languages.entries.map<DropdownMenuItem<String>>(
//                   (MapEntry<String, String> entry) {
//                     return DropdownMenuItem<String>(
//                       value: entry.key,
//                       child: Text(
//                         entry.value,
//                         style: const TextStyle(color: Colors.white, fontSize: 14,
//                         fontWeight: FontWeight.bold,),
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // PDF Viewer Section
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: _buildPdfViewer(),
//               ),
//             ),
//           ),
          
//           // Bottom Action Bar
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Language Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Current Language:',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         languages[selectedLanguage] ?? 'English',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(width: 16),
                
//                 // Download/Print Button
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                     gradient: AppColors.primaryGradient,
//                   ),
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:  Colors.transparent,
//                       foregroundColor: Colors.white,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 20,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: (pdfBytes != null && !isDownloading) 
//                         ? _downloadAndPrintPdf 
//                         : null,
//                     icon: isDownloading
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : const Icon(Icons.download),
//                     label: Text(
//                       isDownloading ? 'Processing...' : 'Download/Print',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPdfViewer() {
//     if (isLoading) {
//       return _buildShimmerLoader();
//     }

//     if (errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               errorMessage!,
//               style: const TextStyle(fontSize: 16, color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadPdfData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (pdfBytes != null) {
//       return PdfPreview(
//         build: (format) => pdfBytes!,
//         allowPrinting: false, // We handle printing separately
//         allowSharing: false,  // We handle sharing separately
//         canChangePageFormat: false,
//         canDebug: false,
//         initialPageFormat: PdfPageFormat.a4,
        

//         previewPageMargin: EdgeInsets.all(0),

//          maxPageWidth: MediaQuery.of(context).size.width,

//         pdfFileName: "${widget.patientId}_Diagnosis_Report_${languages[selectedLanguage]}.pdf",
//       );
//     }

//     return const Center(
//       child: Text('No PDF data available'),
//     );
//   }

//   Widget _buildShimmerLoader() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: [
//           // Shimmer Header (simulating PDF toolbar)
//           Container(
//             height: 60,
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
          
//           // Shimmer PDF Pages
//           Expanded(
//             child: ListView.builder(
//               itemCount: 3, // Show 3 skeleton pages
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 500,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: Colors.grey[200]!,
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       // Header area
//                       Container(
//                         height: 80,
//                         margin: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
                      
//                       // Content lines
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             children: List.generate(
//                               8,
//                               (lineIndex) => Container(
//                                 height: 16,
//                                 margin: const EdgeInsets.only(bottom: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
                      
//                       // Footer area
//                       Container(
//                         height: 40,
//                         margin: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
          
//           // Loading text with shimmer
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Container(
//                   height: 20,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   height: 16,
//                   width: 150,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/pdf.dart';

class DiagnosisPdfViewerPage extends StatefulWidget {
  final String complaintId;
  final String patientId;
  final String diagnosisId;

  const DiagnosisPdfViewerPage({
    required this.complaintId,
    required this.patientId,
    required this.diagnosisId,
    Key? key,
  }) : super(key: key);

  @override
  State<DiagnosisPdfViewerPage> createState() =>
      _DiagnosisPdfViewerPageState();
}

class _DiagnosisPdfViewerPageState extends State<DiagnosisPdfViewerPage> {
  // ─── Cache ────────────────────────────────────────────────────────────────
  // Static so it survives widget rebuilds within the same app session.
  // Key format: "patientId_complaintId_diagnosisId_languageCode"
  static final Map<String, Uint8List> _pdfCache = {};

  /// Unique key for the currently selected language.
  String get _cacheKey =>
      '${widget.patientId}_${widget.complaintId}_${widget.diagnosisId}_$selectedLanguage';

  // ─── State ────────────────────────────────────────────────────────────────
  String selectedLanguage = 'en'; // Default language
  bool isLoading = false;
  bool isDownloading = false;
  Uint8List? pdfBytes;
  String? errorMessage;

  final SecureStorage secureStorage = SecureStorage();

  // Define available languages
  final Map<String, String> languages = {
    'en': 'English',
    'hi': 'हिंदी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'bn': 'বাংলা',
    'gu': 'ગુજરાતી',
    'mr': 'मराठी',
    'pa': 'ਪੰਜਾਬੀ',
  };

  @override
  void initState() {
    super.initState();
    _loadPdfData();
  }

  // ─── Token Refresh ────────────────────────────────────────────────────────
  // NOTE: assumed field/endpoint names, same as pdf_viewer_page.dart — please
  // verify against your actual Constants class / backend route.
  Future<void> refreshtoken() async {
    try {
      Constants.doctorrefreshtoken =
          await secureStorage.readSecureData('doctorrefreshtoken') ?? '';

      final response = await http.post(
        Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitaldoctor/refreshtokendoctorphone'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.doctorrefreshtoken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await secureStorage.writeSecureData(
            'doctortoken', responseData['token']);
        await secureStorage.writeSecureData(
            'doctorrefreshtoken', responseData['refreshToken']);
        Constants.doctortoken = responseData['token'];
        Constants.doctorrefreshtoken = responseData['refreshToken'];
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await secureStorage.deleteSecureData('doctortoken');
        await secureStorage.deleteSecureData('doctorrefreshtoken');
        Constants.doctortoken = '';
        Constants.doctorrefreshtoken = '';
        if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        debugPrint(
            'Refresh failed with status: ${response.statusCode} — ${response.body}');
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }

  // ─── Language Change ──────────────────────────────────────────────────────
  /// Three cases:
  ///   1. Currently loading  → ignored (dropdown is disabled via onChanged: null)
  ///   2. Already cached     → switch instantly, no network call
  ///   3. New language       → update selection, trigger fetch (with shimmer)
  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage == null || newLanguage == selectedLanguage) return;
    if (isLoading) return; // defensive guard

    final pendingKey =
        '${widget.patientId}_${widget.complaintId}_${widget.diagnosisId}_$newLanguage';

    if (_pdfCache.containsKey(pendingKey)) {
      // ✅ Cache hit — instant switch, no spinner
      setState(() {
        selectedLanguage = newLanguage;
        pdfBytes = _pdfCache[pendingKey];
        errorMessage = null;
      });
      return;
    }

    // 🌐 Cache miss — lock dropdown and fetch
    setState(() {
      selectedLanguage = newLanguage;
    });
    _loadPdfData();
  }

  

  // ─── PDF Fetch ────────────────────────────────────────────────────────────
  Future<void> _loadPdfData() async {
    // Snapshot the key at call-time to detect stale responses.
    final String keyAtStart = _cacheKey;

    // Serve from cache if available (handles retry taps on error screen).
    if (_pdfCache.containsKey(keyAtStart)) {
      setState(() {
        pdfBytes = _pdfCache[keyAtStart];
        isLoading = false;
        errorMessage = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Constants.doctortoken =
          await secureStorage.readSecureData('doctortoken') ?? '';

      final String url =
          "${Constants.baseUrl}/api/v1/hospitaldoctor/getindownloaddetailspdf/${widget.patientId}/${widget.complaintId}/${widget.diagnosisId}/$selectedLanguage";

      debugPrint('Fetching PDF: $url');

      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.doctortoken}',
        },
      );

      // ── 401 → refresh token and retry once ──────────────────────────────
      if (response.statusCode == 401) {
        await refreshtoken();
        response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Constants.doctortoken}',
          },
        );
      }

      // ── Handle final response ────────────────────────────────────────────
      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.bodyBytes);

        // Cache regardless of mid-flight language change — useful next time.
        _pdfCache[keyAtStart] = bytes;

        // Only update UI if language hasn't changed while we were waiting.
        if (keyAtStart == _cacheKey && mounted) {
          setState(() {
            pdfBytes = bytes;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load PDF: ${response.statusCode}';
            isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred: $error';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadAndPrintPdf() async {
    if (pdfBytes == null) return;

    setState(() => isDownloading = true);

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes!,
        name:
            '${widget.patientId}_Diagnosis_Report_${languages[selectedLanguage]}.pdf',
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to print/download: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        title: const Text(
          'Diagnosis Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          // Language Dropdown in AppBar
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLanguage,
                // ✅ null disables the dropdown while loading
                onChanged: isLoading ? null : _onLanguageChanged,
                icon: Icon(
                  Icons.arrow_drop_down,
                  // Visual cue that the dropdown is locked
                  color: isLoading ? Colors.white38 : Colors.white,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                dropdownColor: AppColors.secondary,
                items: languages.entries.map<DropdownMenuItem<String>>(
                  (MapEntry<String, String> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
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

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Language Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Current Language:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        languages[selectedLanguage] ?? 'English',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Download/Print Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // ✅ also disabled while loading
                    onPressed:
                        (pdfBytes != null && !isDownloading && !isLoading)
                            ? _downloadAndPrintPdf
                            : null,
                    icon: isDownloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.download),
                    label: Text(
                      isDownloading ? 'Processing...' : 'Download/Print',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
        allowSharing: false, // We handle sharing separately
        canChangePageFormat: false,
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        previewPageMargin: EdgeInsets.all(0),
        maxPageWidth: MediaQuery.of(context).size.width,
        pdfFileName:
            '${widget.patientId}_Diagnosis_Report_${languages[selectedLanguage]}.pdf',
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