import 'package:etiqa_assestment_app/controller/todolist_controller.dart';
import 'package:etiqa_assestment_app/model/todo_model.dart';
import 'package:etiqa_assestment_app/resources/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

class CardItem extends StatefulWidget {
  final TodoModel? todoModel;

  CardItem({this.todoModel, Key? key}) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final _controller = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.todoModel!.todo.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Strings.startDate,
                                style: TextStyle(color: Colors.grey,fontSize: 12)),
                            SizedBox(height: 10),
                            Text(widget.todoModel!.startDate.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Strings.endDate,
                                style: TextStyle(color: Colors.grey,fontSize: 12)),
                            SizedBox(height: 10),
                            Text(widget.todoModel!.endDate.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.todoModel!.isToday == false
                                ? Text(Strings.timerStarts,
                                    style: TextStyle(color: Colors.grey,fontSize: 12))
                                : Text(Strings.timeleft,
                                    style: TextStyle(color: Colors.grey,fontSize: 12)),
                            SizedBox(height: 10),
                            widget.todoModel!.isToday == true
                                ? CountdownTimer(
                                    widgetBuilder:
                                        (_, CurrentRemainingTime? time) {
                                      if (time?.days == null &&
                                          time?.hours != null) {
                                        return Text(
                                            ' ${time?.hours} hrs    ${time?.min} min',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 12));
                                      } else if (time?.days == null &&
                                          time?.hours == null) {
                                        return Text('${time?.min}   min',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 12));
                                      } else {
                                        return Text(
                                            '${time?.days} days   ${time?.hours} hrs ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 12));
                                      }
                                    },
                                    endTime: widget.todoModel!.timeLeft,
                                  )
                                : Text(
                                    "${widget.todoModel!.countdownDays} days",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              Strings.status,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 10),
                            Text(
                                widget.todoModel!.status == false
                                    ? Strings.incomplete
                                    : Strings.complete,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Strings.tickIf),
                            Checkbox(
                              value: _controller.checkBox.value,
                              tristate: false,
                              onChanged: (newValue) {
                                setState(() {
                                  _controller.checkBox.value = newValue!;
                                  if (_controller.checkBox.value == true) {
                                    // To give some delay so that checkbox animation can finish
                                    Future.delayed(Duration(seconds: 1), () {
                                      _controller.removeTodo(widget.todoModel!);
                                      _controller.checkBox.value = false;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
