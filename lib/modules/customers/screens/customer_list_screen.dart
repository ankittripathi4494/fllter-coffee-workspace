// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/widgets/custom_app_bar.dart';
import 'package:filtercoffee/img_list.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_bloc.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_event.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_state.dart';
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
}
