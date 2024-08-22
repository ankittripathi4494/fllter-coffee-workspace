// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/blocs/internet/internet_state.dart';
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
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.deepPurple],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.arguments.containsKey("title")
              ? widget.arguments['title']
              : ''),
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: Colors.deepOrange,
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.white,
              controller: _tabController,
              tabs: const [
                Icon(
                  Icons.camera,
                  size: 50,
                ),
                Icon(
                  Icons.location_history,
                  size: 50,
                ),
                Icon(
                  Icons.grid_3x3,
                  size: 50,
                )
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
                        CameraWidget(
                          state: state,
                        ),
                        LocationWidget(
                          state: state,
                        ),
                        GridViewWidget(
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
