// ignore_for_file: must_be_immutable

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:filtercoffee/global/Localization/app_localizations.dart';
import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/blocs/internet/internet_state.dart';
import 'package:filtercoffee/global/blocs/locale/locale_cubit.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_bloc.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_event.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/global/utils/theme.dart';
import 'package:filtercoffee/global/widgets/my_drawer.dart';
import 'package:filtercoffee/modules/dashboard/widgets/grid_view_widget.dart';
import 'package:filtercoffee/modules/dashboard/widgets/camera_widget.dart';
import 'package:filtercoffee/modules/dashboard/widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../model/country_response_model.dart';

class DashboardScreen extends StatefulWidget {
  late Map<String, dynamic> arguments;
  DashboardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final List<String> items = [];
  bool? darkTheme;

  CountryListResponseData? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  late DashboardBloc dashboardBloc;
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    fetchCountry();
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

  fetchCountry() {
    //! calls on page start
    dashboardBloc = DashboardBloc()..add(FetchCountryListEvent());
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      bloc: InternetCubit(),
      listener: (context, state) {
        if (state == InternetState.internetLost) {
          Navigator.pushReplacementNamed(context, '/network-error-screen');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (darkTheme == true)
                        ? [
                            MaterialTheme.darkScheme().primary,
                            MaterialTheme.darkScheme().primary
                          ]
                        : [
                            MaterialTheme.lightScheme().primary,
                            MaterialTheme.lightScheme().primary
                          ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.arguments.containsKey("title")
              ? AppLocalizations.of(context)!.translate("dashboard")
              : ''),
          centerTitle: true,
          actions: [
            AnimatedToggleSwitch<bool>.dual(
              current: (darkTheme == true) ? true : false,
              first: false,
              second: true,
              spacing: 20.0,
              indicatorSize: const Size(30, 30),
              borderWidth: 5.0,
              height: 35,
              minTouchTargetSize: 20,
              styleBuilder: (value) {
                return (value)
                    ? ToggleStyle(
                        borderColor: (darkTheme == true)
                            ? Colors.white
                            : Colors.transparent,
                        indicatorColor: Colors.white,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      )
                    : ToggleStyle(
                        borderColor: (darkTheme == true)
                            ? Colors.white
                            : Colors.transparent,
                        indicatorColor: Colors.black,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      );
              },
              onChanged: (b) {
                if (b == true) {
                  BlocProvider.of<ThemeSwitcherBloc>(context)
                      .add(ThemeChanged(themeType: true));
                  setState(() {
                    darkTheme = true;
                  });
                } else {
                  BlocProvider.of<ThemeSwitcherBloc>(context)
                      .add(ThemeChanged(themeType: false));
                  setState(() {
                    darkTheme = false;
                  });
                }
              },
              textBuilder: (value) => value
                  ? const Text(
                      "Dark",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      "Light",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
              iconBuilder: (value) => value
                  ? const Icon(
                      Icons.dark_mode,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.light_mode,
                      color: Colors.white,
                    ),
            ),
            DropdownButton(
              underline: Container(),
              isDense: false,
              dropdownColor: Colors.red,
              borderRadius: BorderRadius.circular(20.0),
              items: [
                const DropdownMenuItem(
                  value: Locale('en'),
                  child: Text(
                    'English',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
                const DropdownMenuItem(
                  value: Locale('hi'),
                  child: Text(
                    'हिन्दी',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value!.languageCode == "hi") {
                  print("Hindi :- ${value.languageCode}");
                  BlocProvider.of<LocaleCubit>(context).toHindi();
                } else if (value.languageCode == "en") {
                  print("English :- ${value.languageCode}");
                  BlocProvider.of<LocaleCubit>(context).toEnglish();
                }
              },
              value: AppLocalizations.of(context)!.locale,
            )
          ],
          bottom: TabBar(
              indicatorColor: Colors.deepOrange,
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.white,
              controller: _tabController,
              tabs: const [
                // Icon(
                //   Icons.web,
                //   size: 50,
                // ),
                Icon(
                  Icons.location_history,
                  size: 50,
                ),
                Icon(
                  Icons.grid_3x3,
                  size: 50,
                ),
                Icon(
                  Icons.camera,
                  size: 50,
                ),
              ]),
        ),
        drawer: MyDrawer.getDrawer(context),
        body: BlocProvider(
          create: (_) => dashboardBloc,
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is CountryLoadingSuccessState) {
                return Column(
                  children: [
                    Flexible(
                      child: TabBarView(controller: _tabController, children: [
                        // const WebviewWidget(),
                        LocationWidget(
                          state: state,
                        ),
                        GridViewWidget(
                          state: state,
                        ),
                        CameraWidget(
                          state: state,
                        ),
                      ]),
                    ),
                  ],
                );
              }
              if (state is CountryLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CountryLoadingFailedState) {
                return Center(
                  child: Text(state.errorMessage!),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
