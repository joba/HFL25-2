import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:v04/managers/firestore_data_manager.dart';
import 'package:v04/managers/image_manager.dart';
import 'package:v04/models/search_model.dart';

var env = DotEnv()..load();
final heroDataManager = FirestoreDataManager();
final imageManager = ImageManager();

class ApiManager {
  // Create a singleton instance
  ApiManager._internal();
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;

  final String _baseUrl = 'https://superheroapi.com/api';
  final String _apiKey = env['SUPERHERO_API_KEY'] ?? '';
  final String _imageBaseUrl =
      'https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/sm';

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

  /// Download and save hero image locally
  Future<String> downloadAndSaveHeroImage(
    String imageUrl,
    String heroId,
  ) async {
    final response = await http.get(
      Uri.parse(imageUrl),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'DNT': '1',
        'Connection': 'keep-alive',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download hero image: HTTP ${response.statusCode}',
      );
    }

    // Create images directory if it doesn't exist
    final imagesDir = Directory('images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Get file extension from URL or default to jpg
    final uri = Uri.parse(imageUrl);
    String extension = 'jpg';
    if (uri.pathSegments.isNotEmpty) {
      final lastSegment = uri.pathSegments.last;
      if (lastSegment.contains('.')) {
        extension = lastSegment.split('.').last.toLowerCase();
      }
    }

    // Create local file path
    final fileName = '${heroId}_image.$extension';
    final filePath = 'images/$fileName';
    final file = File(filePath);

    // Write image bytes to file
    await file.writeAsBytes(response.bodyBytes);

    return filePath; // Return the local file path
  }

  /// Download hero image only if it doesn't exist locally
  Future<String?> downloadHeroImageIfNeeded(String name, String heroId) async {
    // Check if image already exists
    final existingPath = imageManager.getLocalHeroImagePath(heroId);
    if (existingPath != null) {
      print('Image already exists for hero $heroId: $existingPath');
      return existingPath;
    }

    // Download if not exists
    try {
      final imageUrl = '$_imageBaseUrl/$heroId-${name.toLowerCase()}.jpg';
      final localPath = await downloadAndSaveHeroImage(imageUrl, heroId);
      print('Downloaded new image for hero $heroId: $localPath');
      return localPath;
    } catch (e) {
      print('Failed to download image for hero $heroId: $e');
      return null;
    }
  }
}
