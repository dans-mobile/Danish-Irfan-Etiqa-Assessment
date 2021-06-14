import 'package:etiqa_assestment_app/controller/todolist_controller.dart';
import 'package:etiqa_assestment_app/resources/Strings.dart';
import 'package:etiqa_assestment_app/widget/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'addtodolist_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  //Get X Controller declaration
  final _controller = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(Strings.todoList, style: TextStyle(color: Colors.black)),
        ),
        body: Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: _controller.todoList.length == 0
                ? Center(
                    child: Text(Strings.plsAddTodo),
                  )
                : ListView.builder(
                    itemCount: _controller.todoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onLongPress: () {
                            Get.to(() => AddToDoListScreen(
                                todoModel: _controller.todoList[index],
                                edit: true));
                            print(index);
                          },
                          child:
                              CardItem(todoModel: _controller.todoList[index]));
                    },
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => AddToDoListScreen(edit: false));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
