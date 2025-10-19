import 'package:v04/models/hero_model.dart';

class SearchModel {
  final String response;
  final String resultsFor;
  final List<HeroModel> results;

  SearchModel({
    required this.response,
    required this.resultsFor,
    required this.results,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      response: json['response'] ?? '',
      resultsFor: json['results-for'] ?? '',
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => HeroModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
