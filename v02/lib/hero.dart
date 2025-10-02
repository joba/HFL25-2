import 'package:uuid/uuid.dart';

// big parts generated with chatgpt, mostly bc I wanted to see how to create the nested classes

class PowerStats {
  final int strength;

  PowerStats({required this.strength});

  factory PowerStats.fromJson(Map<String, dynamic> json) {
    return PowerStats(strength: json['strength']);
  }

  Map<String, dynamic> toJson() {
    return {'strength': strength};
  }
}

class Appearance {
  final String gender;
  final String race;

  Appearance({required this.gender, required this.race});

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(gender: json['gender'] ?? '', race: json['race'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'gender': gender, 'race': race};
  }
}

class Biography {
  final String? alignment;

  Biography({this.alignment});

  factory Biography.fromJson(Map<String, dynamic> json) {
    return Biography(alignment: json['alignment']);
  }

  Map<String, dynamic> toJson() {
    return {'alignment': alignment};
  }
}

class Hero {
  final String id;
  final String name;
  final PowerStats powerstats;
  final Appearance appearance;
  final Biography biography;

  Hero({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.appearance,
    required this.biography,
  });

  factory Hero.add(
    String name,
    int strength,
    String gender,
    String race,
    String alignment,
  ) {
    return Hero(
      id: Uuid().v4(),
      name: name,
      powerstats: PowerStats(strength: strength),
      appearance: Appearance(gender: gender, race: race),
      biography: Biography(alignment: alignment),
    );
  }

  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(
      id: json['id'],
      name: json['name'],
      powerstats: PowerStats.fromJson(json['powerstats'] ?? {}),
      appearance: Appearance.fromJson(json['appearance'] ?? {}),
      biography: Biography.fromJson(json['biography'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'powerstats': powerstats.toJson(),
      'appearance': appearance.toJson(),
      'biography': biography.toJson(),
    };
  }

  @override
  String toString() {
    return '$id: $name (${appearance.gender}, ${appearance.race}), strength: ${powerstats.strength}, alignment: ${biography.alignment}';
  }
}
