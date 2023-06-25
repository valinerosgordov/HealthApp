import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerData {
  final String id;
  final String name;
  final String description;
  final String photo;
  final String site;
  final String appUri;
  final List<Shop> shops;
  final List<String> tags;
  final List<String> categories;
  final Timestamp createAt;
  final String? code;

  PartnerData({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.site,
    required this.appUri,
    required this.shops,
    required this.tags,
    required this.categories,
    required this.createAt,
    this.code,
  });

  factory PartnerData.fromMap({required Map<String, dynamic> map}) {
    return PartnerData(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      photo: map['photo'],
      site: map['site'],
      appUri: map['appUri'],
      shops: (map['shops'] as List<dynamic>).map((e) {
        return Shop.fromMap(map: e);
      }).toList(),
      tags: (map['tags'] as List<dynamic>).map((e) {
        return e.toString();
      }).toList(),
      categories: (map['categories'] as List<dynamic>).map((e) {
        return e.toString();
      }).toList(),
      createAt: map['createAt'],
      code: map['code'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'photo': photo,
      'site': site,
      'appUri': appUri,
      'tags': tags.map((e) {
        return e.toString();
      }).toList(),
      'shops': shops.map((e) {
        return e.toMap();
      }).toList(),
      'categories': categories.map((e) {
        return e.toString();
      }).toList(),
      'createAt': createAt,
      'code': code,
    };
  }

  PartnerData copyWith(
      {String? name,
      String? description,
      String? photo,
      String? site,
      String? appUri,
      List<Shop>? shops,
      List<String>? tags,
      List<String>? categories,
      Timestamp? createAt}) {
    return PartnerData(
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      site: site ?? this.site,
      appUri: appUri ?? this.appUri,
      shops: shops ?? this.shops,
      id: id,
      createAt: createAt ?? this.createAt,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      code: this.code,
    );
  }
}

class Shop {
  final double lat;
  final double lon;
  final Timestamp createAt;

  Shop({required this.lat, required this.lon, required this.createAt});

  factory Shop.fromMap({required Map<String, dynamic> map}) {
    return Shop(
        lat: double.parse(map['lat'].toString()),
        lon: double.parse(map['lon'].toString()),
        createAt: map['createAt']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'lat': lat, 'lon': lon, 'createAt': createAt};
  }
}
