import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DatePickerProject extends StatefulWidget {
  DatePickerProject({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerProject> createState() => _DatePickerEmerchantState();
}

class _DatePickerEmerchantState extends State<DatePickerProject> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
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
        DateTime? pickedDate = await showDatePicker(
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
          });
        }else{
          print("Date is not selected");
        }
      },
    );
  }
}