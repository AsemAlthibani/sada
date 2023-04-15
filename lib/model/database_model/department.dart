class  Department{

  var id,department_name,updated,api;


  Department({this.id, this.department_name, this.updated,this.api});
  factory Department.fromMap(Map<String, dynamic> json) => Department(
    id: json["id"],
    department_name: json["department_name"],
    updated: json["updated"],
    api: json["api"],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department_name': department_name,
      "updated": updated,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'department_name': department_name,
      "updated": updated,
      "api": api,
    };
  }
}
