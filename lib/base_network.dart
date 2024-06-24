import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugasakhirtpm/model/skinmodel.dart';

class BaseNetwork {
  Future<List<Skin>> fetchSkins() async {
    final response = await http
        .get(Uri.parse('https://bymykel.github.io/CSGO-API/api/en/skins.json'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Skin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load skins');
    }
  }
}
