// ignore_for_file: must_be_immutable

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:flutter/material.dart';

class PdfViewScreenPage extends StatelessWidget {
  late Map<String, dynamic> arguments;
  PdfViewScreenPage({
    super.key,
    required this.arguments,
  });

  final String pdfUrl =
      "https://www.antennahouse.com/hubfs/xsl-fo-sample/pdf/basic-link-1.pdf";

  
  Future<PDFDocument> fetchPDF() async {
    try {
      // Fetch and return the PDF document
      return await PDFDocument.fromURL(pdfUrl);
    } catch (e) {
      // Handle errors
      debugPrint("Error fetching PDF: $e");
      rethrow; // Re-throw to allow the FutureBuilder to catch this
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: fetchPDF(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log or show error
            LoggerUtil().debugData("Error: ${snapshot.error}");
            return const Center(child: Text('Error loading PDF'));
          } else if (snapshot.hasData) {
            LoggerUtil().debugData(snapshot.data);
            return PDFViewer(
              backgroundColor: Colors.white,
              document: snapshot.data!,
              lazyLoad: false,
              zoomSteps: 1,
              numberPickerConfirmWidget: const Text(
                "Confirm",
              ),
              pickerButtonColor: Colors.grey,
              pickerIconColor: Colors.white,
            );
          }
          return const CircularProgressIndicator(); // Fallback in case snapshot has no data or error.
        },
      ),
    );
  }
}
