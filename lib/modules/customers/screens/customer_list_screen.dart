// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/utils/database_helper.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/widgets/custom_app_bar.dart';
import 'package:filtercoffee/global/widgets/dialog.dart';
import 'package:filtercoffee/global/widgets/model_bottom_sheet.dart';
import 'package:filtercoffee/img_list.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_bloc.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_event.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global/blocs/internet/internet_cubit.dart';
import '../../../global/blocs/internet/internet_state.dart';

class CustomerListScreen extends StatelessWidget {
  late Map<String, dynamic> arguments;
  CustomerListScreen({
    super.key,
    required this.arguments,
  });

  late CustomerBloc customerBloc = CustomerBloc()
    ..add(FetchCustomerListEvent());
  final DatabaseHelper db = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      bloc: InternetCubit(),
      listener: (context, state) {
        if (state == InternetState.internetLost) {
          Navigator.pushReplacementNamed(context, '/network-error-screen');
        }
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.deepPurple],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWidget.customAppBar(arguments: arguments),
          body: BlocProvider(
            create: (context) => customerBloc,
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is FetchCustomerListLoadedState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.customerList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> selectedCustomer =
                          state.customerList[index];

                      return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight)),
                          child: ListTile(
                            onTap: () {
                              CustomModelBottomSheet
                                  .showCustomModelBottomSheetForDetails(context,
                                      customerDetails: selectedCustomer);
                            },
                            visualDensity: const VisualDensity(vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedCustomer["name"],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/edit-customer',
                                          arguments: {
                                            'title': "Edit Customer",
                                            'selectedCustomer':
                                                selectedCustomer,
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedCustomer["occupation"],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                IconButton(
                                    onPressed: () {
                                      CustomDialog.showDialogDeleteRequest(
                                          context,
                                          barrierDismissible: false,
                                          title: TextButton.icon(
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            onPressed: null,
                                            label: const Text(
                                                "Do you want to delete the customer?"),
                                            icon: const Icon(
                                              CupertinoIcons.delete,
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceAround,
                                          actions: [
                                            TextButton.icon(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              onPressed: () async {
                                                _deleteCustomer(
                                                    context, selectedCustomer);
                                              },
                                              label: const Text("Yes"),
                                              icon: const Icon(
                                                CupertinoIcons
                                                    .check_mark_circled,
                                              ),
                                            ),
                                            TextButton.icon(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.green,
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              label: const Text("No"),
                                              icon: const Icon(
                                                Icons.cancel_rounded,
                                              ),
                                            ),
                                          ]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ));
                    },
                  );
                }
                if (state is FetchCustomerListFailedState) {
                  return Center(
                    child: Image.asset(
                      ImageList.noInternetImage,
                      width: 200,
                      height: 200,
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _deleteCustomer(BuildContext context, Map<String, dynamic> selectedCustomer) {
    Navigator.pop(context);
    CustomDialog.showDialogDeleteRequest(context,
        barrierDismissible: false,
        title: const Center(
          child: CircularProgressIndicator(),
        ));
    Future.delayed(Durations.extralong4, () {
      LoggerUtil().errorData("Deletion Processing");
      db.delete(
          table: "CustomersCredData",
          whereClause: "id=?",
          whereArgs: [selectedCustomer['id']]).then((c) {
        LoggerUtil().errorData("Deletion Process complete");

        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/customer-list',
            arguments: arguments);
      });
    });
  }
}
