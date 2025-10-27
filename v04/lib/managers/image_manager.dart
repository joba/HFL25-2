import 'dart:io';

import 'package:ascii_art_converter/ascii_art_converter.dart';
import 'package:v04/models/hero_model.dart';

class ImageManager {
  ImageManager._internal();
  static final ImageManager _instance = ImageManager._internal();
  factory ImageManager() => _instance;

  Future<void> addAsciiArtToHeroImages(List<HeroModel> heroes) async {
    for (var hero in heroes) {
      if (hero.image != null &&
          hero.image!.url.isNotEmpty &&
          hasLocalHeroImage(hero.id)) {
        final path = getLocalHeroImagePath(hero.id);
        hero.image!.asciiArt = await convertImage(path);
      }
    }
  }

  Future<String> convertImage(String? filePath) async {
    if (filePath == null) return '';

    final image = File(filePath);
    final imageBytes = await image.readAsBytes();
    const converter = AsciiArtConverter(
      width: 50,
      colorMode: ColorMode.trueColor,
    );
    final art = await converter.convert(imageBytes);
    return art;
  }

  /// Check if hero image already exists locally
  bool hasLocalHeroImage(String heroId) {
    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final file = File('images/${heroId}_image.$ext');
      if (file.existsSync()) {
        return true;
      }
    }
    return false;
  }

  /// Get local hero image path if it exists
  String? getLocalHeroImagePath(String heroId) {
    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final filePath = 'images/${heroId}_image.$ext';
      final file = File(filePath);
      if (file.existsSync()) {
        return filePath;
      }
    }
    return null;
  }
}
