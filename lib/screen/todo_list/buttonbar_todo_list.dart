import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottonbarTodolist extends StatefulWidget {
  BottonbarTodolist({
    Key key,
    this.done,
    this.todo,
    this.activity,
  }) : super(key: key);
  final void Function() done;
  final void Function() todo;
  final void Function() activity;

  @override
  State<BottonbarTodolist> createState() => _BottonbarTodolistState();
}

class _BottonbarTodolistState extends State<BottonbarTodolist> {
  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;

    return ListTile(
      tileColor: Colors.white,
      leading: IconButton(
          iconSize: size_width * 0.07,
          color: Colors.blue,
          constraints: BoxConstraints(),
          padding: const EdgeInsets.all(0),
          icon: Icon(Icons.check_box),
          onPressed: widget.done),
      title: IconButton(
          iconSize: size_width * 0.07,
          color: Colors.blue,
          constraints: BoxConstraints(),
          padding: const EdgeInsets.all(0),
          icon: Icon(Icons.list),
          onPressed: widget.todo),
      trailing: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.white),
          onPressed: widget.activity,
          child: Text("Aktivitas User",
              style: TextStyle(
                  fontSize: size_width * 0.045,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600))),
    );
  }
}