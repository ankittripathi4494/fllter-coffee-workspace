// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:filtercoffee/global/widgets/auto_click_button_widget.dart';
import 'package:filtercoffee/global/widgets/custom_app_bar.dart';
import 'package:filtercoffee/global/widgets/form_widgets.dart';
import 'package:filtercoffee/global/widgets/image_picker_widget.dart';
import 'package:filtercoffee/global/widgets/toast_notification.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_bloc.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_event.dart';
import 'package:filtercoffee/modules/customers/bloc/customer_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as i;
import '../../../global/blocs/internet/internet_cubit.dart';
import '../../../global/blocs/internet/internet_state.dart';

class AddCustomerScreen extends StatefulWidget {
  late Map<String, dynamic> arguments;
  AddCustomerScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerAgeController = TextEditingController();
  TextEditingController customerContactController = TextEditingController();
  TextEditingController customerCityController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerPincodeController = TextEditingController();
  TextEditingController customerDistrictController = TextEditingController();
  TextEditingController customerAreaController = TextEditingController();
  TextEditingController customerDOBController = TextEditingController();
  TextEditingController customerOccupationController = TextEditingController();
  int? gender;
  int? married;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
  }

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
        appBar: CustomAppBarWidget.customAppBar(arguments: widget.arguments),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (state is AddCustomerSuccessState)
                        ? AutoClickButtonWidget.automaticTaskWorker(
                            taskWaitDuration: Durations.medium3,
                            task: () async {
                              ToastNotificationWidget.sucessNotification(
                                  context: context,
                                  title: null,
                                  description: state.successMessage);

                              Navigator.pushReplacementNamed(
                                  context, '/customer-list',
                                  arguments: {'title': "Customers List"});
                            },
                            context: context)
                        : Container(),
                    (state is AddCustomerFailedState)
                        ? AutoClickButtonWidget.automaticTaskWorker(
                            taskWaitDuration: Durations.medium3,
                            task: () {
                              ToastNotificationWidget.failedNotification(
                                  context: context,
                                  title: null,
                                  description: state.errorMessage);
                              Navigator.pushReplacementNamed(
                                  context, '/add-customer',
                                  arguments: widget.arguments);
                            },
                            context: context)
                        : Container(),
                    InkWell(
                      onTap: () {
                        ImagePickerWidget.imagePicker(
                          context,
                          galleryFunc: () async {
                            _imagePicker
                                .pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 450,
                                    maxWidth: 450)
                                .then((c) {
                              setState(() {
                                selectedImage = c;
                              });
                            });
                            Navigator.pop(context);
                          },
                          cameraFunc: () async {
                            _imagePicker
                                .pickImage(
                                    source: ImageSource.camera,
                                    maxHeight: 450,
                                    maxWidth: 450)
                                .then((c) {
                              setState(() {
                                selectedImage = c;
                              });
                            });
                             Navigator.pop(context);
                          },
                        );
                      },
                      child: ((selectedImage == null)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.05,
                                  vertical: context.screenHeight * 0.01),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.05,
                                  vertical: context.screenHeight * 0.01),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    FileImage(File(selectedImage!.path)),
                              ),
                            )),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerNameController,
                          keyboardType: TextInputType.name,
                          onChanged: () {},
                          labelText: "Customer Name",
                          prefixIcon: const Icon(CupertinoIcons.person),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerAgeController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Age",
                          prefixIcon: const Icon(CupertinoIcons.number),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerContactController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Contact",
                          prefixIcon: const Icon(CupertinoIcons.phone),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Gender:- ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: genderList
                                  .map((c) => RadioMenuButton(
                                        value: c["input"],
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value;
                                          });
                                          LoggerUtil()
                                              .debugData("Gender :- $gender");
                                        },
                                        child: Text(
                                          c["name"],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Marriage Status:- ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: marriageStatusList
                                  .map((c) => RadioMenuButton(
                                        value: c["input"],
                                        groupValue: married,
                                        onChanged: (value) {
                                          setState(() {
                                            married = value;
                                          });
                                          LoggerUtil()
                                              .debugData("married :- $married");
                                        },
                                        child: Text(
                                          c["name"],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerAddressController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z0-9,/]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Address",
                          prefixIcon: const Icon(Icons.location_city),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerAreaController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z,]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Area",
                          prefixIcon: const Icon(Icons.location_city),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerDistrictController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer District",
                          prefixIcon: const Icon(Icons.location_city),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerCityController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer City",
                          prefixIcon: const Icon(Icons.location_city),
                          errorText: null),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerPincodeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Pincode",
                          prefixIcon: const Icon(CupertinoIcons.phone),
                          errorText: null),
                    ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2100))
                            .then((c) {
                          setState(() {
                            customerDOBController.text = i.DateFormat("d-M-y")
                                .format(c ?? DateTime.now());
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.05,
                            vertical: context.screenHeight * 0.01),
                        child: FormWidgets.buildTextFormField(context,
                            hintText: "dd-mm-yyyy",
                            controller: customerDOBController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Za-z]'))
                            ],
                            onChanged: () {},
                            labelText: "Customer DOB",
                            prefixIcon: const Icon(CupertinoIcons.calendar),
                            errorText: null),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                          vertical: context.screenHeight * 0.01),
                      child: FormWidgets.buildTextFormField(context,
                          controller: customerOccupationController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z\s]'))
                          ],
                          onChanged: () {},
                          labelText: "Customer Occupation",
                          prefixIcon: const Icon(Icons.business_outlined),
                          errorText: null),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          LoggerUtil().debugData("Gender:- $gender");
                          LoggerUtil().debugData("Married:- $married");
                          BlocProvider.of<CustomerBloc>(context).add(
                              AddCustomerEvent(
                                  name: customerNameController.text,
                                  age: customerAgeController.text,
                                  contact: customerContactController.text,
                                  address: customerAddressController.text,
                                  area: customerAreaController.text,
                                  district: customerDistrictController.text,
                                  city: customerCityController.text,
                                  pincode: customerPincodeController.text,
                                  dob: customerDOBController.text,
                                  occupation: customerOccupationController.text,
                                  gender: gender!,
                                  marriage: married!, image: selectedImage));
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
                              "Add Customer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
