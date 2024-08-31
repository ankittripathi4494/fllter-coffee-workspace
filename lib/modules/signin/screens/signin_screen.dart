// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously

import 'package:filtercoffee/global/Localization/app_localizations.dart';
import 'package:filtercoffee/global/widgets/custom_app_bar.dart';
import 'package:filtercoffee/global/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:filtercoffee/global/blocs/internet/internet_cubit.dart';
import 'package:filtercoffee/global/blocs/internet/internet_state.dart';
import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:filtercoffee/global/widgets/auto_click_button_widget.dart';
import 'package:filtercoffee/global/widgets/toast_notification.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_bloc.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_event.dart';
import 'package:filtercoffee/modules/signin/login_bloc/login_state.dart';

class SignInScreen extends StatelessWidget {
  late Map<String, dynamic> arguments;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  SignInScreen({
    super.key,
    required this.arguments,
  });

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
        appBar: CustomAppBarWidget.customAppBar(arguments: arguments),
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Center(
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  (state is LoginFormSuccessState)
                      ? AutoClickButtonWidget.automaticTaskWorker(
                          taskWaitDuration: Durations.medium3,
                          task: () async {
                            ToastNotificationWidget.sucessNotification(
                                context: context,
                                title: null,
                                description: state.successMessage);
                            Navigator.pushReplacementNamed(
                                context, '/dashboard-screen', arguments: {
                              'title': AppLocalizations.of(context)!
                                  .translate("dashboard")
                            });
                          },
                          context: context)
                      : Container(),
                  (state is LoginFormFailedState)
                      ? AutoClickButtonWidget.automaticTaskWorker(
                          taskWaitDuration: Durations.medium3,
                          task: () {
                            if ((state.usernameErrorMessage != null) &&
                                (state.usernameErrorMessage != null)) {
                              ToastNotificationWidget.failedNotification(
                                  context: context,
                                  title: null,
                                  description:
                                      "Incorrect Username and Password");

                              Navigator.pushReplacementNamed(
                                  context, '/login-screen',
                                  arguments: arguments);
                            } else if ((state.usernameErrorMessage == null) &&
                                (state.usernameErrorMessage != null)) {
                              ToastNotificationWidget.failedNotification(
                                  context: context,
                                  title: null,
                                  description: state.passwordErrorMessage);
                              Navigator.pushReplacementNamed(
                                  context, '/login-screen',
                                  arguments: arguments);
                            }
                            if ((state.usernameErrorMessage != null) &&
                                (state.usernameErrorMessage == null)) {
                              ToastNotificationWidget.failedNotification(
                                  context: context,
                                  title: null,
                                  description: state.usernameErrorMessage);
                              Navigator.pushReplacementNamed(
                                  context, '/login-screen',
                                  arguments: arguments);
                            }
                          },
                          context: context)
                      : Container(),
                  //! Username or Email
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: FormWidgets.buildTextFormField(
                      context,
                      controller: usernameController,
                      onChanged: () {
                        BlocProvider.of<LoginBloc>(context).add(
                            LoginTextChangedEvent(
                                usernameValue: usernameController.text,
                                passwordValue: passwordController.text));
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@.]'))
                      ],
                      errorText: (state is LoginFormInValidState)
                          ? state.usernameError
                          : null,
                      labelText: "Username/E-Mail",
                      helperText:
                          "Please Enter data in 'xxxxyew@fe.com' format",
                      hintText: "xxxxyew@fe.com",
                    ),
                  ),

                  //! Password
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: FormWidgets.buildTextFormField(context,
                        controller: passwordController, onChanged: () {
                      BlocProvider.of<LoginBloc>(context).add(
                          LoginTextChangedEvent(
                              usernameValue: usernameController.text,
                              passwordValue: passwordController.text));
                    },
                        obscureText: (state is ToggleChangeStatus)
                            ? state.successMessage
                            : hidePassword,
                        obscuringCharacter: '*',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9@]'))
                        ],
                        errorText: (state is LoginFormInValidState)
                            ? state.passwordError
                            : null,
                        labelText: "Password",
                        hintText: "hjhs@123",
                        suffixIcon: InkWell(
                            onTap: () {
                              BlocProvider.of<LoginBloc>(context).add(
                                  TogglePasswordEvent(
                                      passwordStatus:
                                          (state is ToggleChangeStatus)
                                              ? state.successMessage
                                              : hidePassword));
                            },
                            child: Icon((((state is ToggleChangeStatus)
                                        ? state.successMessage
                                        : hidePassword) ==
                                    true)
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<LoginBloc>(context).add(
                            LoginFormSubmitEvent(
                                usernameData: usernameController.text,
                                passwordData: passwordController.text));
                      },
                      child: Container(
                        height: context.screenSize.height * 0.05,
                        width: context.screenSize.width,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [Colors.green, Colors.blue])),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          textStyle: const TextStyle(fontSize: 14)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register-screen',
                            arguments: {'title': "Register Screen"});
                      },
                      child: const Text("Register Here"))
                ],
              )),
            );
          },
        ),
      ),
    );
  }
}
