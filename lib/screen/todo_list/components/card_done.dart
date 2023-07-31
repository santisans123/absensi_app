import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spo_balaesang/api/api_provider.dart';

class CardDone extends StatefulWidget {
  CardDone({
    Key key,
    this.title,
    this.date,
    this.description,
    this.icon,
    this.color,
    this.status,
    this.id,
  }) : super(key: key);

  final String title;
  final String date;
  final String description;
  final IconData icon;
  final Color color;
  final int status;
  final int id;

  @override
  State<CardDone> createState() => _CardDoneState();
}

class _CardDoneState extends State<CardDone> {

  final ApiProvider apiProvider = Get.find();

  void statusDone(String id) {
    apiProvider.statusDonePersonal({
      'id': int.parse(id),
    }).then((response) {
      print('response ${response.body}');
      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar('Berhasil', 'To Do List telah selesai');
      } else {
        Get.snackbar('Info', 'Gagal ceklis to do list.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          leading: widget.status == null ? Icon(
            widget.icon == null ? Icons.done_outline : widget.icon,
            color: widget.color == null ? Colors.green : widget.color,
            size: 32.0,
          ) :
          Checkbox(
              value: false,
              onChanged: (bool newValue) {
                statusDone(widget.id.toString());
              }),
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.description,
            style: TextStyle(color: Colors.black87),
          ),
          trailing: Text(
            widget.date,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}