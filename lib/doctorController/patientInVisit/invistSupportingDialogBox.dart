import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:hospital_mobile_app/doctorController/pdfViewPage.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class InvisitSupportingFilesDialogBox extends StatefulWidget {
  const InvisitSupportingFilesDialogBox({super.key, required this.patientId, required this.complaintId, required this.diagnosisId,});
  final String patientId;
  final String complaintId;
  final String diagnosisId;

  @override
  State<InvisitSupportingFilesDialogBox> createState() => _InvisitSupportingFilesDialogBoxState();
}

class _InvisitSupportingFilesDialogBoxState extends State<InvisitSupportingFilesDialogBox>
    with TickerProviderStateMixin {
  late Future fetchSupportingFiles;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

    // bool _isDeleting = false;


  @override
  void initState() {
    super.initState();
    
    // Initialize shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _shimmerController.repeat();
    
    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    fetchSupportingFiles = doctorprovider.getinvisitsupportingfiles(widget.patientId, widget.complaintId, widget.diagnosisId);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // Shimmer loading widget
  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 4, // Show 6 shimmer placeholders
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Base shimmer container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade200,
                          Colors.grey.shade100,
                          Colors.grey.shade200,
                        ],
                        stops: [
                          _shimmerAnimation.value - 0.3,
                          _shimmerAnimation.value,
                          _shimmerAnimation.value + 0.3,
                        ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                      ),
                    ),
                  ),
                  // Animated shimmer overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment(-1.0 + 2.0 * _shimmerAnimation.value, 0.0),
                          end: Alignment(1.0 + 2.0 * _shimmerAnimation.value, 0.0),
                          colors: const [
                            Colors.transparent,
                            Colors.white54,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Icon placeholder
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Loading text with animation
  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.file_download_outlined,
              color: Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Loading Supporting Images${'..' * ((_shimmerAnimation.value * 3).floor() + 1)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }

  void downloadImage(String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();

      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');
      //save image to gallery
      await GallerySaver.saveImage(file.path, albumName: 'Hospital Management')
          .then((success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade300,
          content: const Text('Image Downloaded to Gallery!'),
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade300,
        content: const Text('Something went wrong'),
      ));
      log('downloadImageE: $e');
    }
  }

  void shareImage(String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      await Share.shareXFiles([XFile(file.path)], text: filename);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade300,
        content: const Text('Image sharing done successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade300,
        content: const Text('Something Went Wrong (Try again in sometime)!'),
      ));
      print('Something Went Wrong (Try again in sometime)!');
      log('downloadImageE: $e');
    }
  }

  void _viewImage(String imageUrl, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image Viewer'),
            actions: [
              IconButton(
                  onPressed: () => shareImage(imageUrl, filename),
                  icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () => downloadImage(imageUrl, filename),
                  icon: const Icon(Icons.download)),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SupportingFilesAi(
              //           patientId: widget.patientId,
              //           complaintId: widget.complaintId,
              //           fileUrl: imageUrl,
              //         ),
              //       ),
              //     );
              //   },
              //   icon:
              //   SvgPicture.asset('assets/images/iconai.svg',
              //   height: 30,
              //   width: 40,
              //   )
              //   //  const Icon(Icons.lightbulb),
              // ),
            ],
          ),
          body: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 100);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Doctorprovider>(
      builder: (context, doctorprovider, child) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Supporting Documents:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: fetchSupportingFiles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          _buildLoadingText(),
                          const SizedBox(height: 16),
                          _buildShimmerGrid(),
                        ],
                      );
                    }
                    
                    // Stop shimmer animation when loading is complete
                    _shimmerController.stop();
                    
                    return doctorprovider.invisitsupportingfiles.isEmpty?
                      Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              Icons.folder_open,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          SizedBox(height: 10,),
                          Text('No Supporting Files to show..',
                          style: TextStyle(color: Colors.grey.shade700,
                          fontSize: 16),),
                        ],
                      ),)
                    : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: doctorprovider.invisitsupportingfiles.length,
                      itemBuilder: (context, index) {
                        final fileUrl = doctorprovider.invisitsupportingfiles[index];
                        final isImage = fileUrl.endsWith('.png') ||
                            fileUrl.endsWith('.jpg') ||
                            fileUrl.endsWith('.jpeg');
                        final isPdf = fileUrl.endsWith('.pdf');
                        final fileName = fileUrl.split('/').last;

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => isImage
                                  ? _viewImage(fileUrl, fileName)
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewerPage(
                                          url: fileUrl,
                                          filename: fileName,
                                          // patientId: widget.patientId,
                                          // complaintId: widget.complaintId,
                                        ),
                                      ),
                                    ),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade700),
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          fileUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                        ),
                                      )
                                    : isPdf
                                        ? const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40)
                                        : const Icon(Icons.insert_drive_file, color: Colors.black, size: 40),
                              ),
                            ),
                            Positioned(
  top: 2,
  right: 11,
  child: IconButton(
    icon: Icon(Icons.close, color: Colors.red),
    onPressed: () {
      showDialog(
        barrierDismissible: doctorprovider.isDeleting,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Delete File',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you want to delete this file?',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 14)),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14)),
                                  ),
                                ),
                              ),
                              onPressed: doctorprovider.isDeleting ? null : () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 14)),
                                backgroundColor: WidgetStatePropertyAll(
                                    doctorprovider.isDeleting ? Colors.grey : Colors.red),
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14)),
                                  ),
                                ),
                              ),
                              onPressed: doctorprovider.isDeleting ? null : () async {
                                setState(() {
                                  doctorprovider.isDeleting = true;
                                });
                                
                                await doctorprovider.deletediagnosissupportingfile(widget.patientId, widget.complaintId,widget.diagnosisId, fileUrl, context);
                                
                                // setState(() {
                                //   _isDeleting = false;
                                // });
                              },
                              child: doctorprovider.isDeleting 
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  ),
),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}