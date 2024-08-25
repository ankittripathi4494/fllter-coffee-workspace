import 'package:camera/camera.dart';
import 'package:filtercoffee/firebase_options.dart';
import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/utils/location_handler.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/global/widgets/firebase_api_helper.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_bloc.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_bloc.dart';
import 'package:filtercoffee/modules/signup/register_bloc/register_bloc.dart';
import 'package:filtercoffee/router_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the SharedPreferencesHelper
  await SessionHelper().init();
  cameras = await availableCameras();
  // await Permission.camera.request(); // request camera permission
  await LocationHandler.handleLocationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApiHelper().initPart();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LoggerUtil().errorData('Got a message whilst in the foreground!');
    LoggerUtil().errorData('Message data: ${message.data}');

    if (message.notification != null) {
      LoggerUtil().errorData('Message also contained a notification: ${message.notification}');
    }
    LoggerUtil().errorData("title:- ${message.notification?.title??''}\nbody:-${message.notification?.body??''}");
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  LoggerUtil().errorData("Handling a background message: ${message.messageId}");
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
