class PowerStats {
  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  PowerStats(
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  );
}

class Biography {
  final String fullName;
  final String alterEgos;
  final List<String> aliases;
  final String placeOfBirth;
  final String firstAppearance;
  final String publisher;
  final String alignment;

  Biography(
    this.fullName,
    this.alterEgos,
    this.aliases,
    this.placeOfBirth,
    this.firstAppearance,
    this.publisher,
    this.alignment,
  );
}

class Appearance {
  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  Appearance(
    this.gender,
    this.race,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
  );
}

class Work {
  final String occupation;
  final String base;

  Work(this.occupation, this.base);
}

class Connections {
  final String groupAffiliation;
  final String relatives;

  Connections(this.groupAffiliation, this.relatives);
}

class Image {
  final String url;

  Image(this.url);
}

class HeroModel {
  final String id;
  final String name;
  final PowerStats powerStats;
  final Biography biography;
  final Appearance appearance;
  final Work work;
  final Connections connections;
  final Image? image;

  HeroModel(
    this.id,
    this.name,
    this.powerStats,
    this.biography,
    this.appearance,
    this.work,
    this.connections,
    this.image,
  );
}
