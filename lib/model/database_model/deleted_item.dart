class  DeletedItem{

  var id,online_id,
  delete_at,
  delete_by,
  item_type,
  api;


  DeletedItem({this.id, this.online_id, this.delete_at, this.delete_by,
      this.item_type, this.api});

  factory DeletedItem.fromMap(Map<String, dynamic> json) => DeletedItem(
    id: json["id"],
    delete_at: json["delete_at"],
    delete_by: json["delete_by"],
    item_type: json["item_type"],
    online_id: json["online_id"],
    api: json["api"],
  );
  factory DeletedItem.fromMapUpdate(Map<String, dynamic> json) => DeletedItem(
    id: json["id"],
    delete_at: json["delete_at"],
    delete_by: json["delete_by"],
    item_type: json["item_type"],
    online_id: json["online_id"],
    api: json["api"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'delete_at': delete_at,
      'delete_by': delete_by,
      'item_type': item_type,
      "online_id": online_id,
      "api": api,
    };
  }
  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'delete_at': delete_at,
      'delete_by': delete_by,
      'item_type': item_type,
      "online_id": online_id,
      "api": api,    };
  }
}
