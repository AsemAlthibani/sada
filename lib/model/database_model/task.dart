class  Task {

  var id, completion_rate, task_completed, start_date, create_by, end_date,
      department_id, emp_id, task_description,
      task_name, updated, api, date, emp_name, create_by_name, enable_admin,
      online_id, not,for_admin;


  Task({
    this.id,
    this.completion_rate,
    this.task_completed,
    this.create_by_name,
    this.emp_name,
    this.not,
    this.online_id,
    this.enable_admin,
    this.create_by,
    this.start_date,
    this.end_date,
    this.date,
    this.department_id,
    this.emp_id,
    this.task_description,
    this.task_name,
    this.for_admin,
    this.updated,
    this.api});

  factory Task.fromMap(Map<String, dynamic> json) =>
      Task(
        id: json["id"],
        task_name: json["task_name"],
        task_description: json["task_description"],
        date: json["date"],
        emp_id: json["emp_id"],
        not: json["not"],
        online_id: json["online_id"],
        enable_admin: json["enable_admin"]?1:0,
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        emp_name: json["emp_name"],
        department_id: json["department_id"],
        end_date: json["end_date"],
        start_date: json["start_date"],
        task_completed: json["task_completed"]?1:0,
        completion_rate: json["completion_rate"],
        updated: json["updated"],
        api: json["api"],
        for_admin: json["for_admin"]?1:0,
      );

  factory Task.froEmpMap(Map<String, dynamic> json) =>
      Task(
        task_name: json["task_name"],
        task_description: json["task_description"],
        date: json["date"],
        emp_id: json["emp_id"],
        not: json["not"],
        online_id: json["id"],
        enable_admin: json["enable_admin"]?1:0,
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        emp_name: json["emp_name"],
        department_id: json["department_id"],
        end_date: json["end_date"],
        start_date: json["start_date"],
        task_completed: json["task_completed"]?1:0,
        completion_rate: json["completion_rate"],
        updated: json["updated"],
        api: json["api"],
        for_admin: json["for_admin"]?1:0,
      );


  factory Task.fromMapAdmin(Map<String, dynamic> json) =>
      Task(
        task_name: json["task_name"],
        task_description: json["task_description"],
        date: json["date"],
        emp_id: json["emp_id"],
        not: json["not"],
        online_id: json["id"],
        enable_admin: json["enable_admin"]?1:0,
        create_by: json["create_by"],
        create_by_name: json["create_by_name"],
        emp_name: json["emp_name"],
        department_id: json["department_id"],
        end_date: json["end_date"],
        start_date: json["start_date"],
        task_completed: json["task_completed"]?1:0,
        completion_rate: json["completion_rate"],
        updated: json["updated"],
        api: json["api"],
        for_admin: json["for_admin"]?1:0,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': task_name,
      'task_description': task_description,
      'department_id': department_id,
      'end_date': end_date,
      'date': date,
      "not": not,
      "online_id": online_id,
      "enable_admin": enable_admin,
      'start_date': start_date,
      'task_completed': task_completed,
      'create_by': create_by,
      'completion_rate': completion_rate,
      'emp_name': emp_name,
      'create_by_name': create_by_name,
      'emp_id': emp_id,
      "updated": updated,
      "for_admin": for_admin,
      "api": api,
    };
  }
}