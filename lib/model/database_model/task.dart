class  Task{

  var id,completion_rate,task_completed, start_date,create_by, end_date, department_id,user_id, task_description, task_name,updated,api,date;


  Task({
      this.id,
      this.completion_rate,
    this.task_completed,
    this.create_by,
      this.start_date,
      this.end_date,
    this.date,
    this.department_id,
    this.user_id,
      this.task_description,
      this.task_name,
      this.updated,
      this.api});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"],
    task_name: json["task_name"],
    task_description: json["task_description"],
    date: json["date"],
    user_id: json["user_id"],
    create_by: json["create_by"],
    department_id: json["department_id"],
    end_date: json["end_date"],
    start_date: json["start_date"],
    task_completed: json["task_completed"],
    completion_rate: json["completion_rate"],
    updated: json["updated"],
    api: json["api"],

  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': task_name,
      'task_description': task_description,
      'department_id': department_id,
      'end_date': end_date,
      'date': date,
      'start_date': start_date,
      'task_completed': task_completed,
      'create_by': create_by,
      'completion_rate': completion_rate,
      'user_id': user_id,
      "updated": updated,
      "api": api,
    };
  }
}
