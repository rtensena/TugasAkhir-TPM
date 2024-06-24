class Skin {
  final String? id;
  final String? name;
  final String? image;
  final String? description;
  final Rarity? rarity;

  Skin({
    this.id,
    this.name,
    this.image,
    this.description,
    this.rarity,
  });

  factory Skin.fromJson(Map<String, dynamic> json) {
    return Skin(
      id: json['id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      rarity: json['rarity'] != null
          ? Rarity.fromJson(json['rarity'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Rarity {
  final String id;
  final String name;
  final String color;

  Rarity({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Rarity.fromJson(Map<String, dynamic> json) {
    return Rarity(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
    );
  }
}
