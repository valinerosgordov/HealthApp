import 'package:cloud_firestore/cloud_firestore.dart';

class AdData {
  final String id;
  final String name;
  final String photo;
  final String site;
  final String appUri;
  final Timestamp createAt;
  final String sale;
  final String? preview;

  AdData({
    required this.id,
    required this.name,
    required this.sale,
    required this.photo,
    required this.site,
    required this.appUri,
    required this.createAt,
    required this.preview,
  });

  factory AdData.fromMap({required Map<String, dynamic> map}) {
    return AdData(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      site: map['site'],
      sale: map['sale'],
      appUri: map['appUri'],
      createAt: map['createAt'],
      preview: map['preview'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'photo': photo,
      'site': site,
      'sale': sale,
      'appUri': appUri,
      'createAt': createAt,
      'preview': preview,
    };
  }

  AdData copyWith({
    String? name,
    String? description,
    String? photo,
    String? site,
    String? sale,
    String? appUri,
    Timestamp? createAt,
    String? preview,
  }) {
    return AdData(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      site: site ?? this.site,
      sale: sale ?? this.sale,
      appUri: appUri ?? this.appUri,
      id: id,
      createAt: createAt ?? this.createAt,
      preview: preview,
    );
  }
}
