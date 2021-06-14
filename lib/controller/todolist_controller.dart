import 'package:etiqa_assestment_app/model/todo_model.dart';
import 'package:etiqa_assestment_app/screen/todolist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TodoListController extends GetxController {
  //To-Do list
  var todoList = <TodoModel>[].obs;

  //FormKey for TextFormField
  final formKey = GlobalKey<FormState>();

  //Controller for TextFormField
  late TextEditingController todoTittle,
      selectedDateCont,
      selectedSecondDateCont;

  //Date Related
  late DateTime first, second;
  RxBool firstDate = false.obs;
  RxBool secondDate = false.obs;

  RxBool checkBox = false.obs;

  //To enable estimated date only if start date selected
  RxBool firstSelected = false.obs;
  RxBool isToday = false.obs;
  RxBool isEdit = false.obs;

  RxInt countdownDays = 0.obs;

  //Time left var
  late int timeLeft;

  @override
  void onInit() {
    todoTittle = TextEditingController();
    selectedDateCont = TextEditingController();
    selectedSecondDateCont = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    todoTittle.dispose();
    selectedDateCont.dispose();
    selectedSecondDateCont.dispose();
    super.onClose();
  }

  //add To-Do Function
  void addTodo() {
    var generateRandomId = List<int>.generate(999, (i) => i + 1)..shuffle();
    var id = generateRandomId.removeLast();

    TodoModel newTodo = TodoModel(
        id: id.toString() + todoTittle.text.trim(),
        todo: todoTittle.text,
        startDate: selectedDateCont.text,
        endDate: selectedSecondDateCont.text,
        timeLeft: timeLeft,
        timeLeftDateTime: second,
        status: false,
        isToday: isToday.value,
        countdownDays: countdownDays.value);

    print(" Debug add to Json: ${newTodo.toJson()}");

    todoList.add(newTodo);
    resetField();
    Get.offAll(() => TodoListScreen());
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBarAdded);
  }

  void editTodo(TodoModel? todoModel) {
    print("Debug edit 2");
    TodoModel editModel = todoList.firstWhere((element) =>
        element.id.toString().toUpperCase() ==
        todoModel!.id.toString().toUpperCase());

    editModel.todo = todoTittle.text;
    editModel.startDate = selectedDateCont.text;
    editModel.endDate = selectedSecondDateCont.text;
    editModel.timeLeft = timeLeft;
    editModel.timeLeftDateTime = second;
    editModel.isToday = isEdit.value ? isToday.value : todoModel!.isToday;
    editModel.countdownDays = countdownDays.value;

    print(" Debug edit to Json: ${editModel.toJson()}");

    Get.offAll(() => TodoListScreen());
    resetField();

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBarEdit);
  }

  void removeTodo(TodoModel todoModel) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBarDone);
    todoList.remove(todoModel);
    print("Debug list length: ${todoList.length}");
  }

  void resetField() {
    todoTittle.text = "";
    selectedDateCont.text = "";
    selectedSecondDateCont.text = "";
    isToday.value = false;
    countdownDays.value = 0;
    isEdit.value = false;
    print("Debug reset textformfield");
  }

  //Select Date Picker Function
  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final f = new DateFormat('dd MMM yyyy');
    isEdit.value = true;
    print("Debug isEdit: ${isEdit.value}");

    if (firstDate.value == true) {
      print("Debug 1");
      first = args.value;
      selectedDateCont.text = f.format(first);
      firstDate.value = false;
      firstSelected.value = true;

      if (selectedSecondDateCont.text != "") {
        if (first.isAfter(second)) {
          print("Debug clear second date field");
          selectedSecondDateCont.text = "";
        }
      }

      var utcToday = DateTime.now().toUtc();
      var utcFirst = first.toUtc();

      var d1 = DateTime.utc(utcToday.day, utcToday.month, utcToday.year);
      var d2 = DateTime.utc(utcFirst.day, utcFirst.month, utcFirst.year);

      if (d2.day > 0) {
        print("tiber");
        if (d1.compareTo(d2) == 0) {
          print("Debug change 1");
          isToday.value = true;
        } else {
          countdownDays.value = first.difference(DateTime.now()).inDays + 1;
          isToday.value = false;
          print("Debug tak sama hari ${countdownDays.value}");
        }
      }
    } else if (secondDate.value == true) {
      print("Debug 2");
      second = args.value;
      timeLeft = second.millisecondsSinceEpoch;
      selectedSecondDateCont.text = f.format(second);
      secondDate.value = false;

      var utcToday = DateTime.now().toUtc();
      var utcFirst = first.toUtc();

      var d1 = DateTime.utc(utcToday.day, utcToday.month, utcToday.year);
      var d2 = DateTime.utc(utcFirst.day, utcFirst.month, utcFirst.year);

      if (d1.compareTo(d2) == 0) {
        print("Debug change 2");
        isToday.value = true;
      } else {
        countdownDays.value = first.difference(DateTime.now()).inDays + 1;
        print("Debug tak sama hari ${countdownDays.value}");
      }
    }

    print("Debug 4");
    Get.back();
  }

  String? isTextEmpty(String? value) {
    if (value == "") return "Please enter something";
  }

  //snackbar
  final snackBarDone = SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 24.0,
          color: Colors.blue[300],
        ),
        SizedBox(width: 20),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notice", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("You've done a To-Do List"),
            ],
          ),
        ),
      ],
    ),
  );

  final snackBarAdded = SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 24.0,
          color: Colors.blue[300],
        ),
        SizedBox(width: 20),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notice", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("You've added a To-Do List"),
            ],
          ),
        ),
      ],
    ),
  );

  final snackBarEdit = SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 24.0,
          color: Colors.blue[300],
        ),
        SizedBox(width: 20),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notice", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("You've editted a To-Do List"),
            ],
          ),
        ),
      ],
    ),
  );
}
