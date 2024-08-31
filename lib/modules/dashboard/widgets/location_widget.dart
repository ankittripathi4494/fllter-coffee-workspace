// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_bloc.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_event.dart';
import 'package:filtercoffee/global/utils/location_handler.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/global/utils/theme.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationWidget extends StatefulWidget {
  late CountryLoadingSuccessState? state;
  LocationWidget({
    this.state,
    super.key,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget>
    with SingleTickerProviderStateMixin {
  Position? currentPosition;
  String? address;
  late final _animatedMapController = AnimatedMapController(vsync: this);
  bool? darkTheme;
  @override
  void initState() {
     getCurrentTheme();
    super.initState();
  }

  getCurrentTheme() async {
    SessionHelper sph = SessionHelper();

    if (sph.getBool('darkTheme') == true) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ThemeSwitcherBloc>(context)
          .add(ThemeChanged(themeType: true));
      setState(() {
        darkTheme = true;
      });
    } else {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ThemeSwitcherBloc>(context)
          .add(ThemeChanged(themeType: false));
      setState(() {
        darkTheme = false;
      });
    }

    return darkTheme;
  }

  fetchLocationDetails() {
    LocationHandler.getCurrentPosition().then((c) {
      LoggerUtil().errorData(c.toString());
      setState(() {
        currentPosition = c;
      });
      LocationHandler.getCityFromLatLng(c!).then((ad) {
        setState(() {
          address = ad;
        });
      });
    }).onError((cd, kd) {
      LoggerUtil().errorData(cd.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (currentPosition != null)
          ? ((address != null)
              ? mapWidget()
              : Center(
                  child:
                      Text("currentPosition  :-${currentPosition?.toJson()}"),
                ))
          :  Center(
              child: Text("Location Not Fetched", style: TextStyle(
                color: (darkTheme==true)?MaterialTheme.lightScheme().primary:MaterialTheme.darkScheme().primary
              ),),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          fetchLocationDetails();
        },
        label: const Text("Fetch Location"),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  mapWidget() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _animatedMapController.mapController,
          options: MapOptions(
            initialCenter: LatLng(
                currentPosition?.latitude ?? 0.0,
                currentPosition?.longitude ??
                    0.0), // Set the initial center of the map
            initialZoom: 13.0, // Set the initial zoom level
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                      currentPosition?.latitude ?? 0.0,
                      currentPosition?.longitude ??
                          0.0), // Set the marker position
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text("City  :-$address"),
      ],
    );
  }
}
