import 'dart:async';
import 'package:filtercoffee/global/utils/database_helper.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_event.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final DatabaseHelper db = DatabaseHelper();
  CustomerBloc() : super(CustomerInitial()) {
    on<AddCustomerEvent>(_addCustomerMethod);
    on<FetchCustomerListEvent>(_fetchCustomerList);
    on<EditCustomerEvent>(_editCustomerMethod);
  }

  Future<FutureOr<void>> _fetchCustomerList(
      FetchCustomerListEvent event, Emitter<CustomerState> emit) async {
    emit(FetchCustomerListLoadingState());
    try {
      List<Map<String, dynamic>> customerList =
          await db.queryAllRows(table: "CustomersCredData");
      if (customerList.isNotEmpty) {
        emit(FetchCustomerListLoadedState(customerList: customerList));
      } else {
        emit(FetchCustomerListFailedState(errorMessage: "No Data Found"));
      }
    } catch (e) {
      emit(FetchCustomerListFailedState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> _addCustomerMethod(
      AddCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(AddCustomerLoadingState());
    try {
      int outputResult = await db.insert(table: "CustomersCredData", values: {
        'name': event.name,
        'age': event.age,
        'contact': event.contact,
        'city': event.city,
        'address': event.address,
        'pincode': event.pincode,
        'district': event.district,
        'area': event.area,
        'dob': event.dob,
        'gender': event.gender,
        'occupation': event.occupation,
        'married': event.marriage,
      });
      if (outputResult > 0) {
        //insert success
        emit(AddCustomerSuccessState(
            successMessage: "Customer Added Successfully"));
      } else {
        //insert failed
        emit(AddCustomerFailedState(errorMessage: "Customer Added Failed"));
      }
    } catch (e) {
      emit(AddCustomerFailedState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> _editCustomerMethod(
      EditCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(EditCustomerLoadingState());
    try {
      int outputResult = await db.update(
          table: "CustomersCredData",
          values: {
            'name': event.name,
            'age': event.age,
            'contact': event.contact,
            'city': event.city,
            'address': event.address,
            'pincode': event.pincode,
            'district': event.district,
            'area': event.area,
            'dob': event.dob,
            'gender': event.gender,
            'occupation': event.occupation,
            'married': event.marriage,
          },
          whereClause: 'id = ?',
          whereArgs: [event.id]);
      if (outputResult > 0) {
        //update success
        emit(EditCustomerSuccessState(
            successMessage: "Customer Edit Successfully"));
      } else {
        //update failed
        emit(EditCustomerFailedState(errorMessage: "Customer Edit Failed"));
      }
    } catch (e) {
      emit(EditCustomerFailedState(errorMessage: e.toString()));
    }
  }
}
