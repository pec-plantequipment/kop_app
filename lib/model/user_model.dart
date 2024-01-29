class UserModel {
  final String id;
  // final DateTime createdAt;
  final String name;
  final String nameEN;
  // final String avatar;

  UserModel({
    required this.id,
    // required this.createdAt,
    required this.name,
    required this.nameEN,
    // required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        // createdAt: DateTime.parse(json["createdAt"]),
        name: json["customer"],
        nameEN: json["customer_EN"]
        // // avatar: json["avatar"],
        );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name} ${this.nameEN}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.nameEN.toString().contains(filter) || this.name.toString().contains(filter);
       
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => '$name, $nameEN';
 
}
