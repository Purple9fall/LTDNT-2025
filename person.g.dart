// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  name: json['name'] as String,
  email: json['email'] as String,
  address: Address.fromJson(json['address'] as Map<String, dynamic>),
  school: (json['school'] as List<dynamic>)
      .map((e) => School.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'address': instance.address,
  'school': instance.school,
};

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  city: json['city'] as String,
  ward: json['ward'] as String,
  street: json['street'] as String,
  houseNumber: json['houseNumber'] as String,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'city': instance.city,
  'ward': instance.ward,
  'street': instance.street,
  'houseNumber': instance.houseNumber,
};

School _$SchoolFromJson(Map<String, dynamic> json) => School(
  name: json['name'] as String,
  yearIn: (json['yearIn'] as num).toInt(),
  yearOut: (json['yearOut'] as num).toInt(),
  address: json['address'] as String,
);

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
  'name': instance.name,
  'yearIn': instance.yearIn,
  'yearOut': instance.yearOut,
  'address': instance.address,
};
