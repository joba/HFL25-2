import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:v04/models/search_model.dart';

var env = DotEnv()..load();

class ApiManager {
  // Create a singleton instance
  ApiManager._internal();
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;

  final String _baseUrl = 'https://superheroapi.com/api';
  final String _apiKey = env['API_KEY'] ?? '';

  Future<http.Response> fetchHeroById(String id) async {
    final url = '$_baseUrl/$_apiKey/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load hero data: ${response.body}');
    }

    return response;
  }

  Future<SearchModel> searchHeroes(String name) async {
    final url = '$_baseUrl/$_apiKey/search/$name';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SearchModel.fromJson(data);
      } else {
        throw Exception('Failed to search heroes: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to search heroes: $e');
    }
  }
}
