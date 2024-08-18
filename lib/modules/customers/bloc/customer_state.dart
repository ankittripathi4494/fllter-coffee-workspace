// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomerState {}

final class CustomerInitial extends CustomerState {}

//! State for Add Customer Event

class AddCustomerLoadingState extends CustomerState {}

class AddCustomerSuccessState extends CustomerState {
  late String successMessage;
  AddCustomerSuccessState({
    required this.successMessage,
  });
}

class AddCustomerFailedState extends CustomerState {
  late String errorMessage;
  AddCustomerFailedState({
    required this.errorMessage,
  });
}

//! State for Edit Customer Event

class EditCustomerLoadingState extends CustomerState {}

class EditCustomerSuccessState extends CustomerState {
  late String successMessage;
  EditCustomerSuccessState({
    required this.successMessage,
  });
}

class EditCustomerFailedState extends CustomerState {
  late String errorMessage;
  EditCustomerFailedState({
    required this.errorMessage,
  });
}

//! State for Fetch Customer List Event

class FetchCustomerListLoadingState extends CustomerState {}

class FetchCustomerListLoadedState extends CustomerState {
  late List<Map<String,dynamic>> customerList;
  FetchCustomerListLoadedState({
    required this.customerList,
  });
}

class FetchCustomerListFailedState extends CustomerState {
  late String errorMessage;
  FetchCustomerListFailedState({
    required this.errorMessage,
  });
}