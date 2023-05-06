class  Users{

  var id,user_password, user_phone, user_email, isAdmin,user_description, user_name, user_id,department_id,online_id,updated,api,create_by,create_at;


  Users({
    this.id,
    this.user_password,
    this.user_phone,
    this.user_email,
    this.user_description,
    this.user_name,
    this.create_by,
    this.create_at,
    this.online_id,
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
    online_id: json["id"],
    updated: json["updated"],
    create_at: json["create_at"],
    create_by: json["create_by"],
    api: json["api"],
    isAdmin: json["isAdmin"]?1:0,
  );
  factory Users.fromMapUpdate(Map<String, dynamic> json) => Users(
    user_password: json["user_password"],
    user_phone: json["user_phone"],
    user_email: json["user_email"],
    department_id: json["department_id"],
    user_description: json["user_description"],
    user_name: json["user_name"],
    user_id: json["user_id"],
    updated: json["updated"],
    create_at: json["create_at"],
    create_by: json["create_by"],
    api: 1,
    online_id: json["id"],
    isAdmin: json["isAdmin"]?1:0,
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_password': user_password,
      'user_phone': user_phone,
      'department_id': department_id,
      'user_email': user_email,
      'isAdmin': isAdmin,
      'create_by': create_by,
      'online_id': online_id,
      "create_at": create_at,
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
      'online_id': online_id,
      "updated": updated,
      'create_by': create_by,
      "create_at": create_at,
      "api": api,    };
  }
}
