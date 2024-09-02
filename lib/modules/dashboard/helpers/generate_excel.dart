import 'dart:io';

import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/widgets/toast_notification.dart';
import 'package:filtercoffee/main.dart';
import 'package:filtercoffee/modules/dashboard/model/country_response_model.dart';
import 'package:excel/excel.dart' as xls;
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:intl/intl.dart' as i;

generateExcel(BuildContext context,
    {List<CountryListResponseData>? countryListData}) async {
  LoggerUtil().debugData(
      "Export Data as Excel :- ${countryListData!.map((c) => c.toJson())}");
  var excel = xls.Excel.createExcel();
  var sheet = excel.getDefaultSheet();
  // excel.rename(excel.getDefaultSheet()!, "Customer Details");
  // excel.setDefaultSheet("Customer Details");
  sheet = excel.getDefaultSheet();
  var sheetRef = excel[sheet!];

  xls.CellStyle cellHeadingStyle = xls.CellStyle(
      bottomBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      topBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      leftBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      rightBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      verticalAlign: xls.VerticalAlign.Center,
      horizontalAlign: xls.HorizontalAlign.Center,
      bold: true,
      fontSize: 20,
      textWrapping: xls.TextWrapping.WrapText);

  xls.CellStyle cellDataStyle = xls.CellStyle(
      bottomBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      topBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      leftBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      rightBorder: xls.Border(
          borderStyle: xls.BorderStyle.Thin,
          borderColorHex: xls.ExcelColor.fromHexString("#0000ff")),
      verticalAlign: xls.VerticalAlign.Center,
      horizontalAlign: xls.HorizontalAlign.Center,
      bold: false,
      textWrapping: xls.TextWrapping.WrapText);
//! Top Header
  sheetRef.merge(
      xls.CellIndex.indexByString('B2'), xls.CellIndex.indexByString('D3'));
  sheetRef.cell(xls.CellIndex.indexByString('B2')).value =
      xls.TextCellValue("Country List Data");
  sheetRef.cell(xls.CellIndex.indexByString('B2')).cellStyle = cellHeadingStyle;
//! Titles Header
  sheetRef.cell(xls.CellIndex.indexByString('B5')).value =
      xls.TextCellValue("Id");
  sheetRef.cell(xls.CellIndex.indexByString('B5')).cellStyle = cellHeadingStyle;
  sheetRef.merge(
      xls.CellIndex.indexByString('C5'), xls.CellIndex.indexByString('D5'));
  sheetRef.cell(xls.CellIndex.indexByString('C5')).value =
      xls.TextCellValue("Country Name");
  sheetRef.cell(xls.CellIndex.indexByString('C5')).cellStyle = cellHeadingStyle;

//! Content

for (var i = 0; i < countryListData.length; i++) {
    CountryListResponseData xMapDataList =
          countryListData[i];
  sheetRef.cell(xls.CellIndex.indexByString('B${5+i+1}')).value =
      xls.TextCellValue(xMapDataList.id??'');
  sheetRef.cell(xls.CellIndex.indexByString('B${5+i+1}')).cellStyle = cellDataStyle;
  sheetRef.merge(
      xls.CellIndex.indexByString('C${5+i+1}'), xls.CellIndex.indexByString('D${5+i+1}'));
  sheetRef.cell(xls.CellIndex.indexByString('C${5+i+1}')).value =
      xls.TextCellValue(xMapDataList.name??'');
  sheetRef.cell(xls.CellIndex.indexByString('C${5+i+1}')).cellStyle = cellDataStyle;
}

  Directory? directory;
  String baseDirectoryPath = "/storage/emulated/0/Download/FilterCoffee";
  // directory = (await getExternalStorageDirectory())!;
  // print(directory);
  directory = Directory(baseDirectoryPath);
  LoggerUtil().debugData(directory);
  if (directory.existsSync()) {
    if (await mediaStorePlugin.isFileExist(
        fileName: File(
                '${Directory(baseDirectoryPath).path}/${"Customer_Details".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
            .path,
        dirType: DirType.download,
        dirName: DirName.download)) {
      mediaStorePlugin.deleteFile(
          fileName: File(
                  '${Directory(baseDirectoryPath).path}/${"Customer_Details".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
              .path,
          dirType: DirType.download,
          dirName: DirName.download);

      mediaStorePlugin.saveFile(
          tempFilePath: File(
                  '${Directory(baseDirectoryPath).path}/${"Customer_Details".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
              .path,
          dirType: DirType.download,
          dirName: DirName.download);
    } else {
      final List<int> bytes = excel.save()!;
      final file = await File(
              '${Directory(baseDirectoryPath).path}/${"Customer_Details".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
          .writeAsBytes(bytes);
      mediaStorePlugin.saveFile(
          tempFilePath: file.path,
          dirType: DirType.download,
          dirName: DirName.download);
    }
  } else {
    directory.createSync(recursive: true);
    if (await mediaStorePlugin.isFileExist(
        fileName: File(
                '${Directory(baseDirectoryPath).path}/${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
            .path,
        dirType: DirType.download,
        dirName: DirName.download)) {
      mediaStorePlugin.deleteFile(
          fileName: File(
                  '${Directory(baseDirectoryPath).path}/${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
              .path,
          dirType: DirType.download,
          dirName: DirName.download);

      mediaStorePlugin.saveFile(
          tempFilePath: File(
                  '${Directory(baseDirectoryPath).path}/${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
              .path,
          dirType: DirType.download,
          dirName: DirName.download);
    } else {
      final List<int> bytes = excel.save()!;
      final file = await File(
              '${Directory(baseDirectoryPath).path}/${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
          .writeAsBytes(bytes);

      mediaStorePlugin.saveFile(
          tempFilePath: file.path,
          dirType: DirType.download,
          dirName: DirName.download);
    }
  }

//Dispose the excel.

  // Navigator.pop(context);
  // Navigator.pop(context);
  directory = Directory(baseDirectoryPath);
  if (File(
          '${Directory(baseDirectoryPath).path}/${"Customer_Details".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}_xlsx.xlsx')
      .existsSync()) {
    ToastNotificationWidget.failedNotification(
        context: context,
        title: null,
        description:
            "${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}.xlsx file creation Success !!");
  } else {
    ToastNotificationWidget.failedNotification(
        context: context,
        title: null,
        description:
            "${"Cash_transaction_report".replaceAll(" ", "_")}_${i.DateFormat("dd_MM_yyyy").format(DateTime.now())}.xlsx file creation failed !!");
  }
}
