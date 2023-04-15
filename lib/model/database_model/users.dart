class  Users{

  var id,user_password, user_phone, user_email, isAdmin,user_description, user_name, user_id,department_id,updated,api;


  Users({
    this.id,
    this.user_password,
    this.user_phone,
    this.user_email,
    this.user_description,
    this.user_name,
    this.user_id,
    this.isAdmin,
    this.department_id,
    this.updated,
    this.api});

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json["id"],
    user_password: json["user_password"],
    user_phone: json["user_phone"],
    user_email: json["user_email"],
    department_id: json["department_id"],
    user_description: json["user_description"],
    user_name: json["user_name"],
    user_id: json["user_id"],
    updated: json["updated"],
    api: json["api"],
    isAdmin: json["isAdmin"],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_password': user_password,
      'user_phone': user_phone,
      'department_id': department_id,
      'user_email': user_email,
      'isAdmin': isAdmin,
      'user_description': user_description,
      'user_name': user_name,
      'user_id': user_id,
      "updated": updated,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'user_password': user_password,
      'isAdmin': isAdmin,
      'user_phone': user_phone,
      'user_email': user_email,
      'department_id': department_id,
      'user_description': user_description,
      'user_name': user_name,
      'user_id': user_id,
      "updated": updated,
      "api": api,    };
  }
}
