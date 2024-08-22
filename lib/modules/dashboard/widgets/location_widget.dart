// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/utils/location_handler.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationWidget extends StatefulWidget {
  late CountryLoadingSuccessState? state;
  LocationWidget({
    this.state,
    super.key,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Position? currentPosition;
  String? address;
  @override
  void initState() {
    LocationHandler.getCurrentPosition().then((c) {
      setState(() {
        currentPosition = c;
      });
    }).onError((cd, kd) {
      LoggerUtil().errorData(cd.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (currentPosition != null)
          ? ((address !=null)?Center(
              child: Text("Address  :-$address"),
            ):Center(
              child: Text("currentPosition  :-${currentPosition?.toJson()}"),
            ))
          : const Center(
              child: Text("Location Not Fetched"),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          LocationHandler.getCurrentPosition().then((c) {
            LoggerUtil().errorData(c.toString());
            setState(() {
              currentPosition = c;
            });
            LocationHandler.getPostalCodeFromLatLng(c!).then((ad) {
              setState(() {
                address= ad;
              });
            });
          }).onError((cd, kd) {
            LoggerUtil().errorData(cd.toString());
          });
        },
        label: const Text("Fetch Location"),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
