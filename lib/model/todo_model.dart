class TodoModel {
  TodoModel(
      {this.id,
      this.todo,
      this.startDate,
      this.endDate,
      this.timeLeft,
      this.countdownDays,
      this.status,
      this.timeLeftDateTime,
      this.isToday});

  String? id;
  String? todo;
  String? startDate;
  String? endDate;
  int? timeLeft;
  int? countdownDays;
  DateTime? timeLeftDateTime;
  bool? status;
  bool? isToday;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        todo: json["todo"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        timeLeft: json["timeLeft"],
        countdownDays: json["countdownDays"],
        timeLeftDateTime: json["timeLeftDateTime"],
        status: json["status"],
        isToday: json["isToday"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "startDate": startDate,
        "endDate": endDate,
        "timeLeft": timeLeft,
        "countdownDays": countdownDays,
        "timeLeftDateTime": timeLeftDateTime,
        "status": status,
        "isToday": isToday
      };
}
