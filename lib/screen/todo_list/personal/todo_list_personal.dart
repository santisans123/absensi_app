import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date_picker_project.dart';
import 'package:spo_balaesang/screen/todo_list/bottombar_todolist.dart';
import 'package:spo_balaesang/screen/todo_list/personal/bottombar_personal.dart';
import 'package:spo_balaesang/screen/todo_list/user_activity.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class TodoListPersonal extends StatefulWidget {
  TodoListPersonal({
    Key key,
  }) : super(key: key);

  @override
  _TodoListPersonalState createState() => _TodoListPersonalState();
}

class _TodoListPersonalState extends State<TodoListPersonal> {
  User user;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  bool isChecked = false;
  bool isChecked2 = false;

  Future<void> logout() async {
    try {
      Get.defaultDialog(
        title: 'Keluar',
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const <Widget>[
              Icon(
                Icons.dangerous,
                color: Colors.red,
                size: 72,
              ),
              sizedBoxH10,
              Text('Apakah anda yakin ingin keluar dari aplikasi?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Get.back();
              final ProgressDialog pd =
              ProgressDialog(context, isDismissible: false);
              pd.show();
              final dataRepo =
              Provider.of<DataRepository>(context, listen: false);
              final Map<String, dynamic> response = await dataRepo.logout();
              if (response['success'] as bool) {
                final SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.remove(prefsTokenKey);
                prefs.remove(prefsUserKey);
                prefs.remove(prefsAlarmKey);
                pd.hide();
                OneSignal.shared.removeExternalUserId();
                Get.off(() => LoginPage());
              }
            },
            child: const Text(
              'Ya',
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Tidak',
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      showErrorDialog({
        'message': 'Kesalahan',
        'errors': {
          'exception': ['Terjadi kesalahan!']
        }
      });
    }
  }

  void addTodo() {
    final size_width = MediaQuery.of(context).size.width;
    Get.defaultDialog(
      title: 'Tambah To Do List',
      content: Container(
          padding: EdgeInsets.only(right: size_width * 0.01),
          height: size_width / 1.5,
          width: double.maxFinite,
          child: ListView(
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: judulController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan Judul",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              sizedBoxH8,
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: deskripsiController,
                maxLines: 4,
                minLines: 3,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan Deskripsi",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              sizedBoxH16,
              DatePickerProject(),
            ],
          )),
      onConfirm: () {
        Get.back();
      },
      onCancel: () {},
    );
  }

  @override
  void setState(void Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: BottombarPersonal(
          done: () {},
          todo: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              sizedBoxH10,
              const Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                ),
              ),
              dividerT1,
              Card(
                shadowColor: Colors.blue,
                elevation: 5.0,
                child: ListTile(
                  leading: const Icon(
                    Icons.list,
                    color: Colors.indigo,
                    size: 32.0,
                  ),
                  trailing: FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    onPressed: () {
                      addTodo();
                    },
                    child: const Icon(Icons.add),
                  ),
                  title: const Text(
                    'Add ToDoList',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Tambahkan ToDoList',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              sizedBoxH10,
              const Text(
                'To Do List',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                ),
              ),
              dividerT1,
              Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        }),
                    title: Text(
                      'To Do 1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Mengerjakan Front End',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Checkbox(
                        value: isChecked2,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked2 = newValue!;
                          });
                        }),
                    title: Text(
                      'To Do 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Mengerjakan Frontend',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
              ),
              sizedBoxH10,
            ],
          ),
        ),
      ),
    );
  }
}

class ItemRounded extends StatelessWidget {
  ItemRounded({
    required this.image,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    double size_width = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: size_width * 0.015),
        child: Column(
          children: [
            Container(
              width: size_width * 0.15,
              height: size_width * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: size_width * 0.01),
                child: Text(title,
                    style: TextStyle(
                      color: Colors.black,
                    )))
          ],
        ));
  }
}
