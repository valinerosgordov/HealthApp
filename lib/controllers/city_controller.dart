import 'package:get/get.dart';
import 'package:health_app/domain/data/city_data.dart';

import '../domain/repositories/city_repository.dart';

class CityController extends GetxController{
  Rx<List<CityData>> citiesList = Rx<List<CityData>>([]);
  final CityRepository _cityRepository = CityRepository();
  CityData? selectCity;

  Future<List<CityData>> getCities({required String query})async{
    return  await _cityRepository.getCity(query: query);
  }
}