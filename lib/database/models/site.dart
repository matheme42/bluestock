import 'package:bluestock/database/models/model.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:flutter/material.dart';

class Site extends Model {
  late String name;

  /// nom du site
  late String region;

  /// region du site
  List<Zone> zones = [];

  /// zones lies au site

  void fromList(List<dynamic> data) {
    if (data.length != 2) return;
    name = data[0].toString().trim();
    region = data[1].toString().trim();
  }

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey("name") ? name = data["name"].toString().trim() : 0;
    data.containsKey("region") ? region = data["region"].toString().trim() : 0;
    super.fromMap(data);
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['name'] = name.toString();
    message['region'] = region.toString();
    message.addAll(super.asMap());
    return message;
  }

  void print() => debugPrint(asMap().toString());
}
