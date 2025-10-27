import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';
@JsonSerializable()
class Person {
  final String name;
  final String email; 
  final Address address;
  final List<School> school;

  Person({
    required this.name,
    required this.email,
    required this.address,
    required this.school,
  });

  factory Person.fromJson(Map<String, dynamic> json) =>
      _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Address {
  final String city;
  final String ward;
  final String street;
  final String houseNumber;

  Address({
    required this.city,
    required this.ward,
    required this.street,
    required this.houseNumber,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class School {
  final String name;
  final int yearIn;
  final int yearOut;
  final String address;

  School({
    required this.name,
    required this.yearIn,
    required this.yearOut,
    required this.address,
  });

  factory School.fromJson(Map<String, dynamic> json) =>
      _$SchoolFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolToJson(this);
}
