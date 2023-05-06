class  AdminNote{
  var id,emp_id,note_description,updated,api,isAdmin,date, emp_name, create_by_name, online_id, create_by,reports_id,new_add,note_type;

  AdminNote({
      this.id,
      this.emp_id,
      this.note_description,
      this.updated,
      this.api,
    this.isAdmin,
    this.note_type,
      this.date,
    this.emp_name,
    this.reports_id,
    this.create_by_name,
    this.new_add,
      this.online_id,
      this.create_by});

  factory AdminNote.fromMap(Map<String, dynamic> json) => AdminNote(
    id: json["id"],
    note_description: json["note_description"],
    emp_id: json["emp_id"],
    updated: json["updated"],
    reports_id: json["reports_id"],
    isAdmin: json["isAdmin"]?1:0,
    api: json["api"],
    note_type: json["note_type"],
    create_by: json["create_by"],
    online_id: json["online_id"],
    create_by_name: json["create_by_name"],
    emp_name: json["emp_name"],
    date: json["date"],
    new_add: json["new_add"],
  );
  factory AdminNote.fromMapGet(Map<String, dynamic> json) => AdminNote(
    note_description: json["note_description"],
    emp_id: json["emp_id"],
    updated: json["updated"],
    reports_id: json["reports_id"],
    isAdmin: json["isAdmin"],
    api: json["api"],
    create_by: json["create_by"],
    online_id: json["id"],
    note_type: json["note_type"],
    create_by_name: json["create_by_name"],
    emp_name: json["emp_name"],
    date: json["date"],
    new_add: 0,
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_description': note_description,
      'emp_id': emp_id,
      "updated": updated,
      "isAdmin": isAdmin,
      "reports_id": reports_id,
      "api": api,
      "create_by": create_by,
      "online_id": online_id,
      "create_by_name": create_by_name,
      "note_type": note_type,
      "emp_name": emp_name,
      "date": date,
      "new_add": new_add,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'note_description': note_description,
      'emp_id': emp_id,
      "updated": updated,
      "isAdmin": isAdmin,
      "api": api,
      "reports_id": reports_id,
      "create_by": create_by,
      "online_id": online_id,
      "create_by_name": create_by_name,
      "emp_name": emp_name,
      "note_type": note_type,
      "new_add": new_add,
      "date": date,
    };
  }
}