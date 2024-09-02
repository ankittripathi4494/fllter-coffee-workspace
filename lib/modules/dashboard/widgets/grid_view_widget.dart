// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_state.dart';
import 'package:filtercoffee/modules/dashboard/helpers/generate_excel.dart';
import 'package:filtercoffee/modules/dashboard/helpers/generate_pdf.dart';
import 'package:filtercoffee/modules/dashboard/model/country_response_model.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatefulWidget {
  late CountryLoadingSuccessState? state;
  GridViewWidget({
    this.state,
    super.key,
  });

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  elevation: 20,
                  scrollControlDisabledMaxHeightRatio: 0.5,
                  builder: (context) {
                    return Container(
                      width: context.screenWidth,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.deepPurple],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Download As",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.white,
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            onTap: () {
                              generatePDF(context,
                                  countryListData:
                                      widget.state?.countryListData);
                            },
                            title: Text(
                              "Pdf".toString().toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            onTap: () {
                              generateExcel(context, countryListData: widget.state?.countryListData);
                            },
                            title: Text(
                              "Excel".toString().toTitleCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              label: const Text("Download As"),
              icon: const Icon(Icons.download),
            ),
          ),
          Flexible(
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: widget.state?.countryListData!.length,
                itemBuilder: (context, index) {
                  CountryListResponseData? crd =
                      widget.state?.countryListData?[index];
                  return Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.deepPurple],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Center(
                          child: Text(
                        crd?.name ?? '',
                        style: const TextStyle(color: Colors.white),
                      )));
                }),
          ),
        ],
      ),
    );
  }
}
