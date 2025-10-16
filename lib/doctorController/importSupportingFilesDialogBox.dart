import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/pdfViewPage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

class ImportOutvisitSupportingFilesDialogBox extends StatefulWidget {
  const ImportOutvisitSupportingFilesDialogBox({
    super.key,
    required this.fileUrls,
  });
  
  final List<dynamic> fileUrls;

  @override
  State<ImportOutvisitSupportingFilesDialogBox> createState() =>
      _ImportOutvisitSupportingFilesDialogBoxState();
}

class _ImportOutvisitSupportingFilesDialogBoxState
    extends State<ImportOutvisitSupportingFilesDialogBox>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isDeleting = false;
  late List<String> _currentFileUrls;

  @override
  void initState() {
    super.initState();
    _currentFileUrls = List.from(widget.fileUrls);

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
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> downloadImage(
      BuildContext context, String url, String filename) async {
    try {
      log('url: $url');

      final bytes = (await get(Uri.parse(url))).bodyBytes;
      final dir = await getTemporaryDirectory();

      final file = await File('${dir.path}/$filename').writeAsBytes(bytes);

      log('filePath: ${file.path}');

      // Save image to gallery (with custom album)
      final result = await SaverGallery.saveFile(
        file: file.path,
        name: filename,
        androidRelativePath: 'Pictures/Hospital Management',
        androidExistNotSave: false,
      );

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade300,
          content: const Text('Image Downloaded to Gallery!'),
        ));
      } else {
        throw Exception(result.errorMessage);
      }
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
                  onPressed: () => downloadImage(context, imageUrl, filename),
                  icon: const Icon(Icons.download)),
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

  // Future<void> _deleteFile(String fileUrl) async {
  //   setState(() {
  //     _isDeleting = true;
  //   });

  //   try {
  //     // Call the optional delete callback if provided
  //     if (widget.onDelete != null) {
  //       await widget.onDelete!(fileUrl);
  //     }

  //     // Remove from local list
  //     setState(() {
  //       _currentFileUrls.remove(fileUrl);
  //       _isDeleting = false;
  //     });

  //     Navigator.pop(context); // Close delete dialog

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.green.shade300,
  //       content: const Text('File deleted successfully'),
  //     ));
  //   } catch (e) {
  //     setState(() {
  //       _isDeleting = false;
  //     });

  //     Navigator.pop(context); // Close delete dialog

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red.shade300,
  //       content: const Text('Failed to delete file'),
  //     ));
  //     log('deleteFileError: $e');
  //   }
  // }

  // void _showDeleteDialog(String fileUrl) {
  //   showDialog(
  //     barrierDismissible: !_isDeleting,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           return Dialog(
  //             insetPadding: const EdgeInsets.all(16),
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const Text(
  //                     'Delete File',
  //                     style: TextStyle(
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   const Text(
  //                     'Are you sure you want to delete this file?',
  //                     style: TextStyle(fontSize: 18),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           style: const ButtonStyle(
  //                             padding: WidgetStatePropertyAll(
  //                                 EdgeInsets.symmetric(vertical: 14)),
  //                             backgroundColor:
  //                                 WidgetStatePropertyAll(Colors.white),
  //                             shape: WidgetStatePropertyAll(
  //                               RoundedRectangleBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(14)),
  //                               ),
  //                             ),
  //                           ),
  //                           onPressed: _isDeleting
  //                               ? null
  //                               : () {
  //                                   Navigator.pop(context);
  //                                 },
  //                           child: const Text(
  //                             'Close',
  //                             style: TextStyle(color: Colors.black),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 16),
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           style: ButtonStyle(
  //                             padding: const WidgetStatePropertyAll(
  //                                 EdgeInsets.symmetric(vertical: 14)),
  //                             backgroundColor: WidgetStatePropertyAll(
  //                                 _isDeleting ? Colors.grey : Colors.red),
  //                             shape: const WidgetStatePropertyAll(
  //                               RoundedRectangleBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(14)),
  //                               ),
  //                             ),
  //                           ),
  //                           onPressed: _isDeleting
  //                               ? null
  //                               : () async {
  //                                   await _deleteFile(fileUrl);
  //                                 },
  //                           child: _isDeleting
  //                               ? const SizedBox(
  //                                   width: 20,
  //                                   height: 20,
  //                                   child: CircularProgressIndicator(
  //                                     strokeWidth: 2,
  //                                     valueColor: AlwaysStoppedAnimation<Color>(
  //                                         Colors.white),
  //                                   ),
  //                                 )
  //                               : const Text(
  //                                   'Delete',
  //                                   style: TextStyle(color: Colors.white),
  //                                 ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
            _currentFileUrls.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No Supporting Files to show..',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _currentFileUrls.length,
                    itemBuilder: (context, index) {
                      final fileUrl = _currentFileUrls[index];
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
                                      ),
                                    ),
                                  ),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade700),
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        fileUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      ),
                                    )
                                  : isPdf
                                      ? const Icon(Icons.picture_as_pdf,
                                          color: Colors.red, size: 40)
                                      : const Icon(Icons.insert_drive_file,
                                          color: Colors.black, size: 40),
                            ),
                          ),
                          // Positioned(
                          //   top: 2,
                          //   right: 11,
                          //   child: IconButton(
                          //     icon: const Icon(Icons.close, color: Colors.red),
                          //     onPressed: () => _showDeleteDialog(fileUrl),
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}