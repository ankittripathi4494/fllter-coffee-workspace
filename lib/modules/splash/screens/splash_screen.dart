// ignore_for_file: use_build_context_synchronously

import 'package:filtercoffee/global/Localization/app_localizations.dart';
import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/blocs/internet/internet_state.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/modules/splash/widgets/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SessionHelper sp = SessionHelper();
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      bloc: InternetCubit(),
      listener: (context, state) {
        if (state == InternetState.internetAvailable) {
          redirectPage(context);
        }
        if (state == InternetState.internetLost) {
          Navigator.pushReplacementNamed(context, '/network-error-screen');
        }
      },
      child: const Scaffold(
        body: Center(
          child: SplashContent(),
        ),
      ),
    );
  }

  Future<void> redirectPage(BuildContext context) async {
    if (sp.containsKey("isLoggedIn")!) {
      Navigator.pushReplacementNamed(context, '/dashboard-screen', arguments: {
        'title':
            AppLocalizations.of(context)!.translate("dashboard")
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen',
          arguments: {'title': AppLocalizations.of(context)!.translate("loginText")});
    }
  }
}
