import 'package:filtercoffee/modules/customers/screens/add_customer_screen.dart';
import 'package:filtercoffee/modules/customers/screens/customer_list_screen.dart';
import 'package:filtercoffee/modules/customers/screens/edit_customer_screen.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:filtercoffee/modules/dashboard/screens/dashboard_screen.dart';
import 'package:filtercoffee/modules/dashboard/widgets/webview_widget.dart';
import 'package:filtercoffee/modules/error/screens/network_error_screen.dart';
import 'package:filtercoffee/modules/error/screens/page_error_screen.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_bloc.dart';
import 'package:filtercoffee/modules/signin/screens/signin_screen.dart';
import 'package:filtercoffee/modules/signup/screens/signup_screen.dart';
import 'package:filtercoffee/modules/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/customers/bloc/customer_bloc.dart';
import 'modules/signup/register_bloc/register_bloc.dart';

class RouterClassSection {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case '/login-screen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: SignInScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: SignInScreen(
              arguments: const {},
            ),
          ),
        );
      case '/register-screen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RegisterBloc(),
              child: SignUpScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: SignUpScreen(
              arguments: const {},
            ),
          ),
        );

      case '/dashboard-screen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DashboardBloc(),
              child: DashboardScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => DashboardBloc(),
            child: DashboardScreen(
              arguments: const {},
            ),
          ),
        );
      case '/network-error-screen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => NetworkErrorScreen(
              arguments: args,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => NetworkErrorScreen(
            arguments: const {},
          ),
        );

      case '/customer-list':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CustomerBloc(),
              child: CustomerListScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CustomerBloc(),
            child: CustomerListScreen(
              arguments: const {},
            ),
          ),
        );
      case '/add-customer':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CustomerBloc(),
              child: AddCustomerScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CustomerBloc(),
            child: AddCustomerScreen(
              arguments: const {},
            ),
          ),
        );
      case '/edit-customer':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CustomerBloc(),
              child: EditCustomerScreen(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CustomerBloc(),
            child: EditCustomerScreen(
              arguments: const {},
            ),
          ),
        );
      case '/webview_screen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CustomerBloc(),
              child: WebViewScreenPage(
                arguments: args,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CustomerBloc(),
            child: WebViewScreenPage(
              arguments: const {},
            ),
          ),
        );
     
      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    var args = settings.arguments;
    if (args is Map<String, dynamic>) {
      return MaterialPageRoute(
        builder: (context) => PageErrorScreen(
          arguments: args,
        ),
      );
    }
    return MaterialPageRoute(
      builder: (context) => PageErrorScreen(
        arguments: const {},
      ),
    );
  }
}
