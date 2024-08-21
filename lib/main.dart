import 'package:camera/camera.dart';
import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_bloc.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_bloc.dart';
import 'package:filtercoffee/modules/signup/register_bloc/register_bloc.dart';
import 'package:filtercoffee/router_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the SharedPreferencesHelper
  await SessionHelper().init();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // all blocs and cubits must be register here compulsory
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouterClassSection.generateRoute,
      ),
    );
  }
}
