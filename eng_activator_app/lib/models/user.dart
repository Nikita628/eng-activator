class User {
  late int id;
  late String name;

  User({
    required String name,
    required int id,
  }) {
    this.name = name;
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
  }
}
