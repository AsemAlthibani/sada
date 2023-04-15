class  Note{
  var id,emp_id,note_description,updated,api,isAdmin,date, emp_name, create_by_name, online_id, create_by;

  Note({
      this.id,
      this.emp_id,
      this.note_description,
      this.updated,
      this.api,
      this.isAdmin,
      this.date,
      this.emp_name,
      this.create_by_name,
      this.online_id,
      this.create_by});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json["id"],
    note_description: json["note_description"],
    emp_id: json["emp_id"],
    updated: json["updated"],
    isAdmin: json["isAdmin"],
    api: json["api"],
    create_by: json["create_by"],
    online_id: json["online_id"],
    create_by_name: json["create_by_name"],
    emp_name: json["emp_name"],
    date: json["date"],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_description': note_description,
      'emp_id': emp_id,
      "updated": updated,
      "isAdmin": isAdmin,
      "api": api,
      "create_by": create_by,
      "online_id": online_id,
      "create_by_name": create_by_name,
      "emp_name": emp_name,
      "date": date,
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
      "create_by": create_by,
      "online_id": online_id,
      "create_by_name": create_by_name,
      "emp_name": emp_name,
      "date": date,
    };
  }
}