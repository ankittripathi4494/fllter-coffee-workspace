// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/widgets/toast_notification.dart';
import 'package:filtercoffee/modules/dashboard/model/country_response_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

final pdf = pw.Document();
generatePDF(BuildContext context,
    {List<CountryListResponseData>? countryListData}) async {
  desginPdf(countryListData); //

//! Save PDF
  try {
    // Request storage permission
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission not granted');
    }

    // Get the external storage directory
    const directory = "/storage/emulated/0";
    if (directory == null) {
      throw Exception('Failed to get external storage directory');
    }

    // Define the download directory
    final downloadDirectory = Directory('$directory/Download/FilterCoffee');
    LoggerUtil().warningData("downloadDirectory :- $downloadDirectory");
    // Create the download directory if it doesn't exist
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    // Define the file path and save the PDF
    final file = File('${downloadDirectory.path}/country_data.pdf');
    LoggerUtil().warningData("file :- $file");
    pdf.save().then((c) {
      LoggerUtil().warningData("PDF SAve Success :- ${c.toString()}");
      file.writeAsBytes(c).then((d) {
        LoggerUtil().warningData("file write Success :- ${d.toString()}");
      }).onError((f1, k1) =>
          LoggerUtil().warningData("file write Error :- ${f1.toString()}"));
    }).onError((f, k) =>
        LoggerUtil().warningData("PDF SAve Error :- ${f.toString()}"));
    // await file.writeAsBytes(await pdf.save());

    // Send the file path back to the main thread
  } catch (e) {
    // Handle exceptions and errors
    // Handle exceptions and errors

    LoggerUtil().warningData('Error: $e');
  }
}

desginPdf(List<CountryListResponseData>? countryListData) {
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      footer: (context) {
          return pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                  'Powered By Filter Coffee| Page ${context.pageNumber} of ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 12)));
        },
      build: (pw.Context context) {
        return [
          
          pw.Table(
            children: countryListData!
                .map((c) => pw.TableRow(children: [
                      pw.Text(c.id!.toString()),
                      pw.Text(c.name!),
                    ]))
                .toList()),
         
        ]; // Center
      })); //
}
