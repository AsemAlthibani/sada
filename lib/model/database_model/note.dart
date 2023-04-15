class  Note{
  var id,user_id,note_description,updated,api,isAdmin;

  Note({this.id, this.note_description,this.user_id, this.updated,this.api,this.isAdmin});
  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json["id"],
    note_description: json["note_description"],
    user_id: json["user_id"],
    updated: json["updated"],
    isAdmin: json["isAdmin"],
    api: json["api"],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_description': note_description,
      'user_id': user_id,
      "updated": updated,
      "isAdmin": isAdmin,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'note_description': note_description,
      "isAdmin": isAdmin,
      'user_id': user_id,
      "updated": updated,
      "api": api,
    };
  }
}