import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:health_app/other/enum.dart';
import 'ad_data.dart';

class HealthData {
  HealthData({
    required this.id,
    required this.name,
    required this.photo,
    required this.site,
    required this.appUri,
    required this.createAt,
    required this.category,
    this.preview,
    this.status,
    this.info,
    this.isBig = false,
    this.our = false,
    this.photos,
    this.button,
    this.barcode,
  });

  final String id;
  final String name;
  final String photo;
  final String site;
  final String appUri;
  final Timestamp createAt;
  final String? preview;
  final bool? status;
  final Categories category;
  final String? info;
  final bool isBig;
  final bool our;
  final List<String>? photos;
  final String? button;
  final String? barcode;

  factory HealthData.fromMap({required Map<String, dynamic> map}) {
    return HealthData(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      site: map['site'],
      appUri: map['appUri'],
      createAt: map['createAt'],
      preview: map['preview'],
      status: map['status'],
      category: enumFromStringOther(Categories.values, map['category']),
      info: map['info'],
      isBig: map['isBig'] ?? false,
      our: map['our'] ?? false,
      photos: map['photos'] != null
          ? (map['photos'] as List<dynamic>).map((e) => "$e").toList()
          : [],
      button: map['button'],
      barcode: map['barcode'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'photo': photo,
      'site': site,
      'appUri': appUri,
      'createAt': createAt,
      'preview': preview,
      'status': status,
      'category': category.name,
      'info': info,
      'isBig': isBig,
      'our': our,
      'button': button,
      'barcode': barcode,
    };
  }

  HealthData copyWith({
    String? name,
    String? description,
    String? photo,
    String? site,
    String? appUri,
    Timestamp? createAt,
    String? preview,
    bool? status,
    Categories? category,
    String? info,
    bool? isBig,
    bool? our,
    String? button,
    String? barcode,
  }) {
    return HealthData(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      site: site ?? this.site,
      appUri: appUri ?? this.appUri,
      id: id,
      createAt: createAt ?? this.createAt,
      preview: preview,
      status: status,
      category: category ?? this.category,
      info: info,
      isBig: isBig ?? this.isBig,
      our: our ?? this.our,
      button: this.button,
      barcode: this.barcode,
    );
  }
}
