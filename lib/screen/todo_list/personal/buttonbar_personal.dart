import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottonbarPersonal extends StatefulWidget {
  BottonbarPersonal({
    Key key,
    this.done,
    this.todo,
  }) : super(key: key);
  final void Function() done;
  final void Function() todo;

  @override
  State<BottonbarPersonal> createState() => _BottonbarPersonalState();
}

class _BottonbarPersonalState extends State<BottonbarPersonal> {
  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.blueAccent,
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              IconButton(
                  iconSize: size_width * 0.07,
                  color: Colors.white,
                  constraints: BoxConstraints(),
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.check_box),
                  onPressed: widget.done),
              const Text(
                'Done',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                  iconSize: size_width * 0.07,
                  color: Colors.white,
                  constraints: BoxConstraints(),
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.list),
                  onPressed: widget.todo),
              const Text(
                'To Do',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}