import 'dart:convert';


class Meta {
  String label;
  String name;
  String description;

  Meta({
    required this.label,
    required this.name,
    required this.description,
  });

  // Factory constructor to create Meta from JSON
  factory Meta.fromJson(Map<String, dynamic> json) {
    dynamic response = jsonDecode(json['response']['text']);
    return Meta(
      label: response['label'],
      name: response['name'],
      description: response['description'],
    );
  }

  // Convert Meta to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'name': name,
      'description': description,
    };
  }
}

class CleanData {
  String weight;
  List<BasicNutrient> nutrients;
  List<String> ingredients;

  CleanData({
    required this.weight,
    required this.nutrients,
    required this.ingredients,
  });

  // Factory constructor to create CleanData from JSON
  factory CleanData.fromJson(Map<String, dynamic> json) {
    dynamic response = jsonDecode(json['response']['text']);
    return CleanData(
      weight: response['weight'],
      nutrients: List<BasicNutrient>.from(response['nutrients'].map((x) => BasicNutrient.fromJson(x))),
      ingredients: List<String>.from(response['ingredients'].map((x) => x)),
    );
  }

  // Convert CleanData to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'nutrients': nutrients.map((x) => x.toJson()).toList(),
      'ingredients': ingredients,
    };
  }
}

class BasicNutrient {
  String name;
  dynamic value;

  BasicNutrient({
    required this.name,
    required this.value,
  });

  // Factory constructor to create BasicNutrient from JSON
  factory BasicNutrient.fromJson(Map<String, dynamic> json) {
    return BasicNutrient(
      name: json['name'],
      value: json['value'],
    );
  }

  // Convert BasicNutrient to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class Product {
  String label;
  String name;
  String description;
  String imagePath;
  List<Nutrient> nutrients;
  List<Ingredient> ingredients;

  Product({
    required this.label,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.nutrients,
    required this.ingredients,
  });

  // Factory constructor to create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      label: json['label'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      nutrients: List<Nutrient>.from(json['nutrients'].map((x) => Nutrient.fromJson(x))),
      ingredients: List<Ingredient>.from(json['ingredients'].map((x) => Ingredient.fromJson(x))),
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'nutrients': nutrients.map((x) => x.toJson()).toList(),
      'ingredients': ingredients.map((x) => x.toJson()).toList(),
    };
  }
}

class Nutrient {
  String name;
  String description;
  dynamic value;
  String measure;
  String type;

  Nutrient({
    required this.name,
    required this.description,
    required this.value,
    required this.measure,
    required this.type,
  });

  // Factory constructor to create Nutrient from JSON
  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      name: json['name'],
      description: json['description'] ?? '',
      value: json['value'],
      measure: json['measure'],
      type: json['type'],
    );
  }

  // Convert Nutrient to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'value': value,
      'measure': measure,
      'type': type,
    };
  }
}

class Ingredient {
  String name;
  String description;
  int rating;

  Ingredient({
    required this.name,
    required this.description,
    required this.rating,
  });

  // Factory constructor to create Ingredient from JSON
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      description: json['description'],
      rating: json['rating'],
    );
  }

  // Convert Ingredient to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'rating': rating,
    };
  }
}
