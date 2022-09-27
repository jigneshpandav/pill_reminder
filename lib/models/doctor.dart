import 'package:hive_flutter/hive_flutter.dart';

part 'doctor.g.dart';

@HiveType(typeId: 3)
class Doctor {
  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _speciality;
  @HiveField(3)
  String? _photo;
  @HiveField(4)
  String? _phoneNo;
  @HiveField(5)
  String? _officeNo;
  @HiveField(6)
  String? _email;
  @HiveField(7)
  String? _note;

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  String? get speciality => _speciality;

  set speciality(String? value) {
    _speciality = value;
  }

  String? get photo => _photo;

  set photo(String? value) {
    _photo = value;
  }

  String? get phoneNo => _phoneNo;

  set phoneNo(String? value) {
    _phoneNo = value;
  }

  String? get officeNo => _officeNo;

  set officeNo(String? value) {
    _officeNo = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get note => _note;

  set note(String? value) {
    _note = value;
  }

  Doctor({
    String? id,
    String? name,
    String? speciality,
    String? photo,
    String? phoneNo,
    String? officeNo,
    String? email,
    String? note,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _speciality = json['speciality'];
    _photo = json['photo'];
    _phoneNo = json['phoneNo'];
    _officeNo = json['officeNo'];
    _email = json['email'];
    _note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['speciality'] = _speciality;
    data['photo'] = _photo;
    data['phoneNo'] = _phoneNo;
    data['officeNo'] = _officeNo;
    data['email'] = _email;
    data['note'] = _note;
    return data;
  }
}
