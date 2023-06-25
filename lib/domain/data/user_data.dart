import 'dart:ffi';

class UserData{
  final String uuId;
  final String phoneNumber;
  final String name;
  final String soname;
  final String photoUri;
  final String city;
  final String id;
  final bool active;
  final List<String> partnersLikes;

  UserData({required this.uuId, required this.phoneNumber,
  required this.name,
  required this.soname,
  required this.photoUri,
  required this.city,
    required this.partnersLikes,
    required this.active,
  required this.id});


  UserData copyWith({
  String? uuId,
    String? phoneNumber,
    String? name,
    String? soname,
    String? photoUri,
    String? city,
    String? id,
    bool? active,
    List<String>? partnersLikes
}){
    return UserData(uuId: uuId ?? this.uuId,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        soname: soname ?? this.soname,
        photoUri: photoUri ?? this.photoUri,
        city: city ?? this.city,
        active: active ?? this.active,
        partnersLikes: partnersLikes ?? this.partnersLikes,
        id: id ?? this.id);

  }

  @override
  String toString() {
    return 'UserData(name:${name}, soname:${soname}, uuId:$uuId, partnersLikes:$partnersLikes'
        'phoneNumber: $phoneNumber, photoUri:$photoUri, city:$city, id:$id active:${active}'
        ')';
  }



  factory UserData.fromMap({required Map<String, dynamic> map}){
    return UserData(
        uuId: map['uuId'],
        phoneNumber: map['phoneNumber'],
        name: map['name'],
        soname: map['soname'],
        photoUri: map['photoUri'],
        city: map['city'],
        active: map['active'],
        id: map['id'], partnersLikes: (map['partnersLikes'] as List<dynamic>).map((e) {
          return e.toString();
    }).toList());
  }

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'uuId':this.uuId,
      'phoneNumber':this.phoneNumber,
      'name':this.name,
      'soname': this.soname,
      'photoUri':this.photoUri,
      'city':this.city,
      'id':this.id,
      'active':this.active,
      'partnersLikes': this.partnersLikes.map((e) {return e.toString();}).toList(),
    };
  }


}