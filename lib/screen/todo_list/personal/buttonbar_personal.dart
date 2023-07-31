import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottonbarPersonal extends StatefulWidget {
  BottonbarPersonal({
    Key key,
    this.done,
    this.un_done,
  }) : super(key: key);
  final void Function() done;
  final void Function() un_done;

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
          GestureDetector(
            onTap: widget.done,
            child: Row(
              children: [
                Icon(Icons.check_box),
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
          ),
          GestureDetector(
            onTap: widget.un_done,
            child: Row(
              children: [
                Icon(Icons.close_sharp),
                const Text(
                  'Un Done',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
