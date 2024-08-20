import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:flutter/material.dart';

class CustomModelBottomSheet {
  static showCustomModelBottomSheetForDetails(BuildContext context,
      {Map<String, dynamic>? customerDetails}) {
    return showModalBottomSheet(
      context: context,
      elevation: 20,
      scrollControlDisabledMaxHeightRatio:0.9,
      builder: (context) {
        return Container(
          width: context.screenWidth,
          child: Column(
            children: [
              const Text(
                "Customer Details Section",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.black,
                height: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              (customerDetails!.isNotEmpty)
                  ? Flexible(
                      child: (ListView.builder(
                        shrinkWrap: true,
                        itemCount: (customerDetails.entries.toList()).length,
                        itemBuilder: (context, index) {
                          MapEntry<String, dynamic> m =
                              (customerDetails.entries.toList())[index];
                          return ListTile(
                            title: Text(
                              m.key.toString().toTitleCase(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: getValueData(m),
                          );
                        },
                      )),
                    )
                  : const Text("No Data Available"),
            ],
          ),
        );
      },
    );
  }

  static Text getValueData(MapEntry<String, dynamic> m) {
    switch (m.key) {
      case 'gender':
        int genderindex = genderList.indexWhere((d) =>
            (int.parse(d['input'].toString().trim().toLowerCase()) ==
                int.parse(m.value.toString().trim().toLowerCase())));

        return Text(
          genderList[genderindex]['name'].toString(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
        );
      case 'married':
        int marriedindex = marriageStatusList.indexWhere((d) =>
            (int.parse(d['input'].toString().trim().toLowerCase()) ==
                int.parse(m.value.toString().trim().toLowerCase())));

        return Text(
          marriageStatusList[marriedindex]['name'].toString(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
        );
      default:
        return Text(
          m.value.toString(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
        );
    }
  }
}
