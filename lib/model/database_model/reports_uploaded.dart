class  ReportsUploaded {

  var id, create_by,  file_url,
  file_name, api, date,  create_by_name,
      online_id, not,file_path,isAdmin,downloaded,new_add;


  ReportsUploaded({
    this.id,
    this.create_by_name,
    this.not,
    this.online_id,
    this.create_by,
    this.file_url,
    this.file_name,
    this.file_path,
    this.date,
    this.downloaded,
    this.isAdmin,
    this.new_add,
    this.api});

  factory ReportsUploaded.fromMap(Map<String, dynamic> json) =>
      ReportsUploaded(
        id: json["id"],
        file_name: json["file_name"],
        file_path: json["file_path"],
        file_url: json["file_url"],
        isAdmin: json["isAdmin"]?1:0,
        downloaded: json["downloaded"],
        date: json["date"],
        not: json["not"],
        online_id: json["online_id"],
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        api: json["api"],
        new_add: json["new_add"],
      );

  factory ReportsUploaded.fromMapGet(Map<String, dynamic> json) =>
      ReportsUploaded(
        file_name: json["file_name"],
        file_path: json["file_path"],
        file_url: json["file_url"],
        isAdmin: json["isAdmin"]?1:0,
        downloaded: json["downloaded"],
        date: json["date"],
        not: json["not"],
        online_id: json["id"],
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        api: json["api"],
        new_add: json["new_add"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      "not": not,
      "online_id": online_id,
      'create_by': create_by,
      'create_by_name': create_by_name,
      'downloaded': downloaded,
      'isAdmin': isAdmin,
      'file_name': file_name,
      'file_path': file_path,
      "file_url": file_url,
      "api": api,
      "new_add": new_add,
    };
  }
}