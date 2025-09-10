import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.url,
    required this.filename,
    // required this.patientId,
    // required this.complaintId,
  });

  final String url;
  final String filename;
  // final String patientId;
  // final String complaintId;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage>
    with SingleTickerProviderStateMixin {
  PDFViewController? _pdfController;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isLoading = true;
  String? _filePath;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _downloadAndLoadPdf();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _downloadAndLoadPdf() async {
    try {
      // Download the PDF
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) throw Exception('Failed to download PDF');

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${widget.filename}');
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        _filePath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      log('Error downloading PDF: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.red.shade300,
      //     content: const Text('Failed to load PDF.'),
      //   ),
      // );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPdfLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // SizedBox(height: 50),

          // Loading PDF message with animated dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 12),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  int dotCount = ((_animationController.value * 3) % 4).floor();
                  return Text(
                    "Loading PDF${"." * dotCount}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 40),

          // PDF page shimmer effect
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header area shimmer
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey[300]!,
                                Colors.grey[100]!,
                                Colors.grey[300]!,
                              ],
                              stops: [
                                _animationController.value - 0.3,
                                _animationController.value,
                                _animationController.value + 0.3,
                              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                              begin: Alignment(-1.0, 0.0),
                              end: Alignment(1.0, 0.0),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),

                    // Content lines shimmer
                    ...List.generate(
                        12,
                        (index) => Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    height: 14,
                                    width: _getLineWidth(index),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[300]!,
                                          Colors.grey[100]!,
                                          Colors.grey[300]!,
                                        ],
                                        stops: [
                                          (_animationController.value -
                                                  0.3 +
                                                  index * 0.1) %
                                              1.0,
                                          (_animationController.value +
                                                  index * 0.1) %
                                              1.0,
                                          (_animationController.value +
                                                  0.3 +
                                                  index * 0.1) %
                                              1.0,
                                        ]
                                            .map((stop) => stop.clamp(0.0, 1.0))
                                            .toList(),
                                        begin: Alignment(-1.0, 0.0),
                                        end: Alignment(1.0, 0.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Page indicator shimmer
          // S,
        ],
      ),
    );
  }

  double _getLineWidth(int index) {
    final screenWidth =
        MediaQuery.of(context).size.width - 72; // Account for padding
    switch (index % 4) {
      case 0:
        return screenWidth;
      case 1:
        return screenWidth * 0.85;
      case 2:
        return screenWidth * 0.7;
      case 3:
        return screenWidth * 0.9;
      default:
        return screenWidth;
    }
  }

  Future<void> downloadPdf(
      BuildContext context, String url, String filename) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading PDF...')),
      );

      // Download the PDF
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }

      // Get the downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      print(downloadsDir.path);

      // Create Hospital Management folder if it doesn't exist
      final hospitalDir = Directory('${downloadsDir.path}/Hospital Management');
      if (!await hospitalDir.exists()) {
        await hospitalDir.create(recursive: true);
      }

      // Save the PDF file
      final file = File('${hospitalDir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade300,
          content: Text('PDF Downloaded to Downloads/Hospital Management'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      log('Download PDF error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade300,
          content: const Text('Failed to download PDF. Please try again.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _goToPage(int page) {
    if (_pdfController != null && page >= 0 && page < _totalPages) {
      _pdfController!.setPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          // IconButton(
          //   onPressed: _isLoading || _filePath == null
          //       ? null
          //       : () => Share.shareXFiles([_filePath!], text: 'PDF Document'),
          //   icon: const Icon(Icons.share),
          // ),
          IconButton(
            onPressed: () => downloadPdf(context, widget.url, widget.filename),
            icon: const Icon(Icons.download),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SupportingFilesAi(
          //           patientId: widget.patientId,
          //           complaintId: widget.complaintId,
          //           fileUrl: widget.url,
          //         ),
          //       ),
          //     );
          //   },
          //   icon:
          //    SvgPicture.asset('assets/images/iconai.svg',
          //       height: 30,
          //       width: 40,
          //       )
          //   // const Icon(Icons.lightbulb),
          // ),
        ],
      ),
      body: _isLoading
          ? _buildPdfLoadingShimmer()
          : _filePath == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load PDF',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    PDFView(
                      filePath: _filePath!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageSnap: true,
                      fitPolicy: FitPolicy.BOTH,
                      // onRender: (pages) {
                      //   setState(() {
                      //     _totalPages = pages ?? 0;
                      //   });
                      // },
                      // onViewCreated: (PDFViewController pdfViewController) {
                      //   _pdfController = pdfViewController;
                      // },
                      // onPageChanged: (page, total) {
                      //   setState(() {
                      //     _currentPage = page ?? 0;
                      //   });
                      // },
                    ),
                    // Positioned navigation controls (commented out as in original)
                  ],
                ),
    );
  }
}
