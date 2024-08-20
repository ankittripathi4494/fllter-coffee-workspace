// ignore_for_file: non_constant_identifier_names

import 'package:filtercoffee/global/utils/database_helper.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/modules/signup/register_bloc/register_event.dart';
import 'package:filtercoffee/modules/signup/register_bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global/utils/shared_preferences_helper.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SessionHelper sp = SessionHelper();
  final DatabaseHelper db = DatabaseHelper();

  RegisterBloc() : super(RegisterInitial()) {
    //! Map Event 1 with States according to logic
    on<RegisterTextChangedEvent>(_onTextChangedEvent);

    //! Map Event 2 with States according to logic
    on<RegisterFormSubmitEvent>(_onFormSubmitEvent);

    //! Map Event 3 with States according to logic
    on<TogglePasswordRegisterEvent>(_togglePasswordEvent);
  }

  void _onTextChangedEvent(
      RegisterTextChangedEvent event, Emitter<RegisterState> emit) {
    if (event.usernameValue.isEmpty && event.passwordValue.isEmpty) {
      emit(RegisterFormInvalidState(
          usernameError: "Please Enter Username",
          passwordError: "Please Enter Password"));
    } else if (event.usernameValue.isNotEmpty && event.passwordValue.isEmpty) {
      emit(RegisterFormInvalidState(
          usernameError: null, passwordError: "Please Enter Password"));
    } else if (event.usernameValue.isEmpty && event.passwordValue.isNotEmpty) {
      emit(RegisterFormInvalidState(
          usernameError: "Please Enter Username", passwordError: null));
    } else {
      emit(RegisterFormValidState());
    }
  }

  Future<void> _onFormSubmitEvent(
      RegisterFormSubmitEvent event, Emitter<RegisterState> emit) async {
    try {
      final users = await db.queryRowByClause(
        table: "UserCredData",
        whereClause: "username=? and password=?",
        whereArgs: [event.usernameData, event.passwordData],
      );

      if (users!.isNotEmpty) {
        LoggerUtil().errorData("Data already exist please login.");
        emit(RegisterFormFailedState(
            errorMessage: "Data already exists, please login."));
      } else {
        try {
          db.insert(table: "UserCredData", values: {
            'username': event.usernameData,
            'password': event.passwordData,
          });
          LoggerUtil().infoData("Registration successful.");
          emit(RegisterFormSuccessState(
              successMessage: "Registration Successful"));
        } catch (e) {
          LoggerUtil().errorData(e.toString());
          emit(RegisterFormFailedState(
              errorMessage: "Registration failed: ${e.toString()}"));
        }
      }
    } catch (e) {
      LoggerUtil().errorData(e.toString());
      emit(RegisterFormFailedState(
          errorMessage: "Registration failed: ${e.toString()}"));
    }
  }

  void _togglePasswordEvent(
      TogglePasswordRegisterEvent event, Emitter<RegisterState> emit) {
    late bool passwordStatus;
    passwordStatus = !event.passwordStatus;
    emit(ToggleChangeRegisterStatus(successMessage: passwordStatus));
  }
}
