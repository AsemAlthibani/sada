class  Employees{

  var id,department_id,user_id, employees_name,updated,api,isAdmin;


  Employees({
    this.id,
    this.department_id,
    this.employees_name,
    this.user_id,
    this.updated,
    this.api,this.isAdmin});

  factory Employees.fromMap(Map<String, dynamic> json) => Employees(
    id: json["id"],
    department_id: json["department_id"],
    employees_name: json["employees_name"],
    user_id: json["user_id"],
    updated: json["updated"],
    isAdmin: json["isAdmin"]?1:0,
    api: json["api"],
  );
  factory Employees.fromMapUpdate(Map<String, dynamic> json) => Employees(
    isAdmin:json["isAdmin"]?1:0,
    user_id:json["user_id"],
    employees_name:json["user_name"],
    department_id:json["department_id"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department_id': department_id,
      'employees_name': employees_name,
      'user_id': user_id,
      "isAdmin": isAdmin,
      "updated": updated,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      "isAdmin": isAdmin,
      'department_id': department_id,
      'employees_name': employees_name,
      'user_id': user_id,
      "updated": updated,
      "api": api,    };
  }
}
