import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _photo;

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get name => _name;

  String? get photo => _photo;

  set photo(String? value) {
    _photo = value;
  }

  set name(String? value) {
    _name = value;
  }

  User({
    String? id,
    String? name,
    String? photo,
  });

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['photo'] = _photo;
    return data;
  }
}
