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
      child: Scaffold(
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
                    Map<String, dynamic> data = state.customerList[index];
                    return ListTile(
                      title: Text(data["name"]),
                      subtitle: Text(data["occupation"]),
                    );
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
    );
  }
}
