import 'dart:convert';
import 'dart:io';


Future<String> readjson() async {
  // Đọc file JSON từ assets
  final file = File('Basic/data.json');
  return file.readAsString();
}

class Address {
   String _city;
   String _ward;
   String _street;
   String _houseNumber;
  Address(this._city, this._ward, this._street, this._houseNumber);
}

class School{
   String _name;
   int _yearIn;
   int _yearOut;
   String _address;
  School(this._name, this._address, this._yearIn, this._yearOut);
}

class User{
   String _name;
   String _email;
   Address _address;
   List<School> _schools;
  
  User(this._name, this._email, this._address, this._schools);
  factory User.fromJson(Map<String, dynamic> json) => User(
        json['name'] as String,
        json['email'] as String,
        Address(
          json['address']['city'] as String,
          json['address']['ward'] as String,
          json['address']['street'] as String,
          json['address']['houseNumber'] as String,
        ),
        (json['schools'] as List<dynamic>)
            .map((schoolJson) => School(
                  schoolJson['name'] as String,
                  schoolJson['address'] as String,
                  schoolJson['yearIn'] as int,
                  schoolJson['yearOut'] as int,
                ))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': _name,
        'email': _email,
        'address': {
          'city': _address._city,
          'ward': _address._ward,
          'street': _address._street,
          'houseNumber': _address._houseNumber,
        },
        'schools': _schools
            .map((school) => {
                  'name': school._name,
                  'address': school._address,
                  'yearIn': school._yearIn,
                  'yearOut': school._yearOut,
                })
            .toList(),
      };

}

Future<void> main() async{
  String jsonString = await readjson();
  Map<String,dynamic> decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
  User user = User.fromJson(decodedJson);
  print('Tên: ${user._name}');
  print('Email: ${user._email}');
  print('Địa chỉ:${user._address._houseNumber},${user._address._street},${user._address._ward},${user._address._city}');
  print('Trường học: ${user._schools.map((school) => school._name).join(', ')}');  
}
// dart Serial2.dart