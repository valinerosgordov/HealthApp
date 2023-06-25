import 'dart:convert';

import '../data/city_data.dart';
import 'package:http/http.dart' as http;

class CityRepository {
  Map<String, String> get headers =>
      {
        "Content-Type": "application/json",
        "X-Secret": "54a25ea97cc94d6728787c2aac655510b90052e4",
        "Authorization": "Token 812f7ca42f597f8d9b68e6d99fd3ee16ae96b7b9",
      };

  Future<List<CityData>> getCity({required String query}) async {
    Map<String, String> body = {
      "query": "$query"
    };
    var response = await http.post(Uri.parse(
        "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address?query=$query"),
        headers: headers, body: jsonEncode(body));

    print("value is ${response.body}");
    print(response.headers["value"]);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)["suggestions"];
      List<CityData> result = <CityData>[];

      for (int i = 0; i < data.length; i++) {
        try {
          if (data[i]['data']['city']
              .toString()
              .isNotEmpty && data[i]['data']['city']
              .toString()
              .length > 2) {
            if (result
                .where((element) =>
            element.value == data[i]['data']['city'].toString())
                .isEmpty) {
              result.add(CityData.fromMap(map: data[i]['data']));
            }
          }
        } catch (e) {
          print('city error ${e}');
        }
      }

      return result;
    } else {
      throw Exception();
    }
  }
}