// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, avoid_print
import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:filtercoffee/global/Localization/app_localizations_setup.dart';
import 'package:filtercoffee/global/blocs/locale/locale_cubit.dart';
import 'package:filtercoffee/global/blocs/locale/locale_state.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_bloc.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_state.dart';
import 'package:filtercoffee/global/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';

GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final mediaStorePlugin = MediaStore();
late List<CameraDescription> cameras;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'filter_coffee_channel', // id
    'High Importance Notifications', // title
    ledColor: Color.fromARGB(255, 48, 20, 97),
    importance: Importance.high,
    playSound: true,
    enableLights: true);
bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

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
  await MediaStore.ensureInitialized();
  // From API 33, we request photos, audio, videos permission to read these files. This the new way
  // From API 29, we request storage permission only to read access all files
  // API lower than 30, we request storage permission to read & write access access all files

  // For writing purpose, we are using [MediaStore] plugin. It will use MediaStore or java File based on API level.
  // It will use MediaStore for writing files from API level 30 or use java File lower than 30
  List<Permission> permissions = [
    Permission.storage,
  ];

  if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
    permissions.add(Permission.photos);
    permissions.add(Permission.audio);
    permissions.add(Permission.videos);
  }

  await permissions.request();
  // we are not checking the status as it is an example app. You should (must) check it in a production app

  // You have set this otherwise it throws AppFolderNotSetException
  MediaStore.appFolder = "FilterCoffee";

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: callOnFrontNotification,
      onDidReceiveBackgroundNotificationResponse: callOnFrontNotification);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LoggerUtil().errorData('Got a message whilst in the foreground!');
    LoggerUtil().errorData('Message data: ${message.data}');

    if (message.notification != null) {
      LoggerUtil().errorData(
          'Message also contained a notification: ${message.notification}');
    }

    LoggerUtil().errorData(
        "title:- ${message.notification?.title ?? ''}\nbody:-${message.notification?.body ?? ''}");
    int id = Random().nextInt(1678877);
    // RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.pendingNotificationRequests()
        .then((value) => value.any((element) => element.id == id))
        .then((v5) {
      if (v5) {
        // Cancel the existing notification
        flutterLocalNotificationsPlugin.cancel(id);
      }
      flutterLocalNotificationsPlugin.show(
          id,
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: "@drawable/app_icon",
              // other properties...
              importance: Importance.max,
              priority: Priority.high,
              enableVibration: true,
              enableLights: true,
              colorized: true,
              color: Colors.deepPurple,
              playSound: true,
              sound: const UriAndroidNotificationSound(
                  "resources/tunes/notification_sound.mp3"),
            ),
          ),
          payload: message.data["TYPE"]);
    }).catchError((vx5) {
      print("The notification Error $vx5");
    });
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp(
    data: 'djd',
  ));
}

callOnFrontNotification(NotificationResponse details) async {
  LoggerUtil().infoData("callOnFrontNotification ${details.payload}");
  await Navigator.pushReplacementNamed(
    _navigatorKey.currentContext!,
    '/customer-list',
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  LoggerUtil().errorData("Handling a background message: ${message.messageId}");
  int id = Random().nextInt(1678877);
  // RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.pendingNotificationRequests()
      .then((value) => value.any((element) => element.id == id))
      .then((v5) {
    if (v5) {
      // Cancel the existing notification
      flutterLocalNotificationsPlugin.cancel(id);
    }
    flutterLocalNotificationsPlugin.show(
        id,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: "@drawable/app_icon",
            // other properties...
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            enableLights: true,
            colorized: true,
            color: Colors.deepPurple,
            playSound: true,
            sound: const UriAndroidNotificationSound(
                "resources/tunes/notification_sound.mp3"),
          ),
        ),
        payload: message.data["TYPE"]);
  }).catchError((vx5) {
    print("The notification Error $vx5");
  });
}

class MyApp extends StatelessWidget {
  String? data;
  late Locale? _locale;
  MyApp({
    super.key,
    this.data,
  }) {
    _loadLangData();
  }
  _loadLangData() async {
    _locale = Locale(SessionHelper().getString("lang")!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadLangData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                BlocProvider<ThemeSwitcherBloc>(
                  create: (context) => ThemeSwitcherBloc(),
                ),
                BlocProvider<LocaleCubit>(
                  create: (context) => LocaleCubit(),
                ),
              ],
              child: BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  Locale? appLocale = localeState is SelectedLocale
                      ? localeState.locale
                      : _locale;
                  return BlocBuilder<ThemeSwitcherBloc, ThemeSwitcherState>(
                    builder: (context, themeState) {
                      ThemeData appTheme = themeState is ThemeDarkModeState
                          ? ThemeData(
                              useMaterial3: true,
                              textTheme: createTextTheme(
                                  context, "Abyssinica SIL", "Aboreto"),
                              colorScheme: MaterialTheme.darkScheme())
                          : (themeState is ThemelightModeState
                              ? ThemeData(
                                  useMaterial3: true,
                                  textTheme: createTextTheme(
                                      context, "Abyssinica SIL", "Aboreto"),
                                  colorScheme: MaterialTheme.lightScheme())
                              : ThemeData(
                                  useMaterial3: true,
                                  textTheme: createTextTheme(
                                      context, "Abyssinica SIL", "Aboreto"),
                                  colorScheme: MaterialTheme.lightScheme()));

                      return MaterialApp(
                        navigatorKey: _navigatorKey,
                        debugShowCheckedModeBanner: false,
                        initialRoute: '/',
                        theme: appTheme,
                        supportedLocales:
                            AppLocalizationsSetup.supportedLocales,
                        localizationsDelegates:
                            AppLocalizationsSetup.localizationsDelegates,
                        localeResolutionCallback:
                            AppLocalizationsSetup.localeResolutionCallback,
                        locale: appLocale,
                        onGenerateRoute: RouterClassSection.generateRoute,
                      );
                    },
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
