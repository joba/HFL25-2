import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:v04/firebase_config.dart';
import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/managers/data_manager.dart';
import 'package:v04/models/hero_model.dart';

class FirestoreDataManager implements HeroDataManaging {
  // Create a singleton instance
  FirestoreDataManager._internal();
  static final FirestoreDataManager _instance =
      FirestoreDataManager._internal();
  factory FirestoreDataManager() => _instance;

  final String _collectionName = 'heroes';
  bool _loaded = false;

  // Delegate business logic operations to DataManager
  final DataManager _dataManager = DataManager();

  @override
  List<HeroModel> heroes = [];

  String get _baseUrl => FirebaseConfig.databaseUrl;
  String get _apiKey => FirebaseConfig.apiKey;

  @override
  Future<String> saveHero(HeroModel hero) async {
    if (!_loaded) {
      await loadHeroes();
    }

    // Prevent duplicates
    final existingIndex = heroes.indexWhere((h) => h.id == hero.id);
    if (existingIndex >= 0) {
      return 'duplicatedEntry';
    }

    try {
      final url = '$_baseUrl/$_collectionName/${hero.id}?key=$_apiKey';

      // Firestore REST API expects the document to be wrapped in a "fields" object
      final firestoreDocument = {
        'fields': _convertToFirestoreFormat(hero.toJson()),
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(firestoreDocument),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save hero: ${response.body}');
      }

      _loaded = false;
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  @override
  Future<void> loadHeroes() async {
    if (_loaded) return; // Prevent reloading if already loaded

    try {
      final url = '$_baseUrl/$_collectionName?key=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['documents'] != null) {
          heroes = (data['documents'] as List)
              .map((doc) {
                try {
                  // Extract ID from document name (e.g., "projects/.../documents/heroes/70" -> "70")
                  final docName = doc['name'] as String;
                  final heroId = docName.split('/').last;

                  // Safely convert document fields
                  final fields = doc['fields'] as Map<String, dynamic>? ?? {};
                  final convertedData = _convertFromFirestoreFormat(fields);

                  // Add the ID to the converted data
                  convertedData['id'] = heroId;

                  return HeroModel.fromJson(convertedData);
                } catch (e) {
                  print('Error parsing hero document: $e');
                  print('Document: $doc');
                  return null; // Return null for invalid documents
                }
              })
              .where((hero) => hero != null) // Filter out null heroes
              .cast<HeroModel>()
              .toList();
        } else {
          heroes = [];
        }
      } else if (response.statusCode == 404) {
        // Collection doesn't exist yet
        heroes = [];
      } else {
        throw Exception('Failed to load heroes: ${response.body}');
      }

      _loaded = true;
    } catch (e) {
      print('Error loading heroes from Firestore: $e');
      heroes = []; // Return empty list on error
    }
  }

  // Search in local saved heroes - delegates to DataManager
  @override
  Future<List<HeroModel>> searchHeroes(String searchTerm) async {
    if (!_loaded) {
      await loadHeroes();
    }
    return _dataManager.searchHeroes(heroes, searchTerm);
  }

  @override
  HeroModel parseData(Map<String, dynamic> json) {
    return HeroModel.fromJson(json);
  }

  // Delegate sorting to DataManager
  @override
  List<HeroModel> sortHeroes(String? sortBy, [int? limit]) {
    return _dataManager.sortHeroes(heroes, sortBy, limit);
  }

  // Delegate filtering to DataManager
  @override
  List<HeroModel> filterHeroes(String? filterBy, String? filterValue) {
    return _dataManager.filterHeroes(heroes, filterBy, filterValue);
  }

  // Delete a hero from Firestore
  Future<void> deleteHero(String heroId) async {
    try {
      final url = '$_baseUrl/$_collectionName/$heroId?key=$_apiKey';
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete hero: ${response.body}');
      }

      // Remove from local cache
      heroes.removeWhere((hero) => hero.id == heroId);
    } catch (e) {
      print('Error deleting hero from Firestore: $e');
      throw Exception('Failed to delete hero: $e');
    }
  }

  // Convert regular JSON to Firestore format
  Map<String, dynamic> _convertToFirestoreFormat(Map<String, dynamic> json) {
    Map<String, dynamic> firestoreDoc = {};
    json.forEach((key, value) {
      // Skip the 'id' field as it's handled by Firestore document ID
      if (key == 'id' || value == null) return;

      if (value is String) {
        firestoreDoc[key] = {'stringValue': value};
      } else if (value is int) {
        firestoreDoc[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        firestoreDoc[key] = {'doubleValue': value};
      } else if (value is bool) {
        firestoreDoc[key] = {'booleanValue': value};
      } else if (value is List) {
        firestoreDoc[key] = {
          'arrayValue': {
            'values': value
                .map((item) => {'stringValue': item.toString()})
                .toList(),
          },
        };
      } else if (value is Map<String, dynamic>) {
        firestoreDoc[key] = {
          'mapValue': {'fields': _convertToFirestoreFormat(value)},
        };
      }
    });

    return firestoreDoc;
  }

  // Convert Firestore format back to regular JSON
  Map<String, dynamic> _convertFromFirestoreFormat(
    Map<String, dynamic> firestoreDoc,
  ) {
    Map<String, dynamic> json = {};

    firestoreDoc.forEach((key, value) {
      // Handle null or empty values
      if (value == null) {
        json[key] = null;
        return;
      }

      // Handle different Firestore value types
      if (value['stringValue'] != null) {
        json[key] = value['stringValue'];
      } else if (value['integerValue'] != null) {
        json[key] = int.tryParse(value['integerValue'].toString()) ?? 0;
      } else if (value['doubleValue'] != null) {
        json[key] = value['doubleValue'];
      } else if (value['booleanValue'] != null) {
        json[key] = value['booleanValue'];
      } else if (value['nullValue'] != null) {
        json[key] = null;
      } else if (value['arrayValue'] != null &&
          value['arrayValue']['values'] != null) {
        json[key] = (value['arrayValue']['values'] as List).map((item) {
          if (item == null) return '';
          return item['stringValue']?.toString() ?? item.toString();
        }).toList();
      } else if (value['mapValue'] != null &&
          value['mapValue']['fields'] != null) {
        json[key] = _convertFromFirestoreFormat(value['mapValue']['fields']);
      } else {
        // Fallback for unknown types
        json[key] = null;
      }
    });

    return json;
  }
}
