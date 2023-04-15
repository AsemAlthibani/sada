class  ReportsUploaded {

  var id, create_by,  file_url,
  file_name, api, date,  create_by_name,
      online_id, not,file_path;


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
    this.api});

  factory ReportsUploaded.fromMap(Map<String, dynamic> json) =>
      ReportsUploaded(
        id: json["id"],
        file_name: json["file_name"],
        file_path: json["file_path"],
        file_url: json["file_url"],
        date: json["date"],
        not: json["not"],
        online_id: json["online_id"],
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        api: json["api"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      "not": not,
      "online_id": online_id,
      'create_by': create_by,
      'create_by_name': create_by_name,
      'file_name': file_name,
      'file_path': file_path,
      "file_url": file_url,
      "api": api,
    };
  }
}