class CityData{
  final double lat;
  final double lon;
  final String value;
  
  CityData({required this.lat, required this.lon,
  required this.value});

  factory CityData.fromMap({required Map<String, dynamic> map}){
    print(map);
    return CityData(lat: double.tryParse(map['geo_lat'])??0.0,
        lon: double.tryParse(map['geo_lon']) ??0.0, value: map['city']?? '');
  }
  
}