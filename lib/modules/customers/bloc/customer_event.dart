// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';

class CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  late String name;
  late String age;
  late String contact;
  late String address;
  late String area;
  late String district;
  late String city;
  late String pincode;
  late String dob;
  late String occupation;
  late int gender;
  late int marriage;
  late XFile? image;
  AddCustomerEvent({
    required this.name,
    required this.age,
    required this.contact,
    required this.address,
    required this.area,
    required this.district,
    required this.city,
    required this.pincode,
    required this.dob,
    required this.occupation,
    required this.gender,
    required this.marriage,
    required this.image
  });
}

class EditCustomerEvent extends CustomerEvent {
  late String id;
  late String name;
  late String age;
  late String contact;
  late String address;
  late String area;
  late String district;
  late String city;
  late String pincode;
  late String dob;
  late String occupation;
  late int gender;
  late int marriage;
   late XFile? image;
  EditCustomerEvent({
    required this.id,
    required this.name,
    required this.age,
    required this.contact,
    required this.address,
    required this.area,
    required this.district,
    required this.city,
    required this.pincode,
    required this.dob,
    required this.occupation,
    required this.gender,
    required this.marriage,
    required this.image
  });
}

class FetchCustomerListEvent extends CustomerEvent {}
