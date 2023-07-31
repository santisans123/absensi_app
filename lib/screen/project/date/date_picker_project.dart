import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spo_balaesang/screen/project/date/date_controller.dart';

final dateProject = new GlobalKey<_DatePickerState>();

class DatePickerProject extends StatefulWidget {
  DatePickerProject({
    Key key,
    this.date
  }) : super(key: key);

  final String date;

  @override
  State<DatePickerProject> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerProject> {
  TextEditingController dateinput = TextEditingController();

  final DateController dateController = Get.find();

  @override
  void initState() {
    dateinput.text = widget.date == null ? "" : widget.date; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: dateinput,
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          labelText: "Enter Date"
      ),
      readOnly: true,
      onTap: () async {
        DateTime pickedDate = await showDatePicker(
            context: context, initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101)
        );

        if(pickedDate != null ){
          print(pickedDate);
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          print(formattedDate);

          setState(() {
              dateinput.text = formattedDate;
              dateController.setdate(dateinput.text);
          });
        }else{
          print("Date is not selected");
        }
      },
    );
  }
}