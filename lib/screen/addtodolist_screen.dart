import 'package:etiqa_assestment_app/controller/todolist_controller.dart';
import 'package:etiqa_assestment_app/model/todo_model.dart';
import 'package:etiqa_assestment_app/resources/Strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddToDoListScreen extends StatefulWidget {
  final TodoModel? todoModel;
  final bool? edit;

  AddToDoListScreen({this.todoModel, this.edit, Key? key}) : super(key: key);

  @override
  _AddToDoListScreenState createState() => _AddToDoListScreenState();
}

class _AddToDoListScreenState extends State<AddToDoListScreen> {
  TodoListController _controller = Get.find();

  @override
  void initState() {
    //Populate Field if edit
    if (widget.edit == true) {
      _controller.todoTittle.text = widget.todoModel!.todo.toString();
      _controller.selectedDateCont.text =
          widget.todoModel!.startDate.toString();
      _controller.selectedSecondDateCont.text =
          widget.todoModel!.endDate.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _controller.resetField();
          Get.back();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                _controller.resetField();
                Get.back();
              },
            ),
            backgroundColor: Colors.orange,
            title: Text(Strings.addTodo, style: TextStyle(color: Colors.black)),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _controller.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.todoTittle,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      todoField(),
                      SizedBox(height: 10),
                      Text(Strings.startDate,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      startDateField(),
                      SizedBox(height: 10),
                      Text(Strings.endDate,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      endDateField(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomButton(),
        ),
      ),
    );
  }

  startDateField() {
    return TextFormField(
        validator: (value) {
          return _controller.isTextEmpty(value);
        },
        onTap: () async {
          _controller.firstDate.value = true;
          Get.dialog(AlertDialog(
            content: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: SfDateRangePicker(
                  enablePastDates: false,
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: _controller.onSelectionChanged,
                  view: DateRangePickerView.year,
                )),
          ));
        },
        readOnly: true,
        controller: _controller.selectedDateCont,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(),
          hintText: Strings.selectDate,
          hintStyle: TextStyle(color: Colors.grey),
        ));
  }

  endDateField() {
    return Obx(
      () => TextFormField(
          enabled: _controller.firstSelected.value,
          controller: _controller.selectedSecondDateCont,
          validator: (value) {
            return _controller.isTextEmpty(value);
          },
          onTap: () async {
            _controller.secondDate.value = true;
            Get.dialog(AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: SfDateRangePicker(
                    minDate: _controller.first.add(const Duration(days: 1)),
                    enablePastDates: false,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: _controller.onSelectionChanged,
                    view: DateRangePickerView.year,
                  )),
            ));
          },
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(),
            hintText: Strings.selectDate,
            hintStyle: TextStyle(color: Colors.grey),
          )),
    );
  }

  bottomButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (_controller.formKey.currentState!.validate()) {
            if (widget.edit == false) {
              _controller.addTodo();
            } else
              _controller.editTodo(widget.todoModel);
          }
        },
        child:
            widget.edit == false ? Text(Strings.createNew) : Text(Strings.edit),
        style: ElevatedButton.styleFrom(primary: Colors.black),
      ),
    );
  }

  todoField() {
    return TextFormField(
      controller: _controller.todoTittle,
      validator: (value) {
        return _controller.isTextEmpty(value);
      },
      maxLines: 3,
      decoration: InputDecoration(
          hintText: Strings.plsKeyInTodo,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder()),
    );
  }
}
