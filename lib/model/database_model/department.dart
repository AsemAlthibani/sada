class  Department{

  var id,department_name,updated,api,create_by,create_at,online_id;


  Department({this.id, this.department_name, this.updated,this.api,this.create_by,this.create_at,this.online_id});
  factory Department.fromMap(Map<String, dynamic> json) => Department(
    id: json["id"],
    department_name: json["department_name"],
    updated: json["updated"],
    online_id: json["online_id"],
    create_at: json["create_at"],
    create_by: json["create_by"],
    api: json["api"],
  );
  factory Department.fromMapGet(Map<String, dynamic> json) => Department(
    department_name: json["department_name"],
    updated: json["updated"],
    online_id: json["online_id"],
    create_at: json["create_at"],
    create_by: json["create_by"],
    api: json["api"],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department_name': department_name,
      "updated": updated,
      'create_by': create_by,
      'online_id': online_id,
      "create_at": create_at,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'department_name': department_name,
      "updated": updated,
      'create_by': create_by,
      'online_id': online_id,
      "create_at": create_at,
      "api": api,
    };
  }
}
