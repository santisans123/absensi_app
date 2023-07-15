import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date_picker_project.dart';
import 'package:spo_balaesang/screen/todo_list/bottombar_todolist.dart';
import 'package:spo_balaesang/screen/todo_list/list_done.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class UserActivity extends StatefulWidget {
  UserActivity({
    Key? key,
  }) : super(key: key);

  @override
  _UserActivityState createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  late User user;
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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Icon(Icons.arrow_back, color: Colors.white)),
            ],
          ),
        ),
        title: const Text('Aktivitas Tim'),
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
                'Member',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                ),
              ),
              dividerT1,
              Card(
                elevation: 2.0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(ListDone());
                  },
                  child: ListTile(
                    leading: ItemRounded(image: 'assets/images/santi.jpeg'),
                    title: Text(
                      'Member 1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Bagian: Developer',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ),
              ),
              sizedBoxH6,
              Card(
                elevation: 2.0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(ListDone());
                  },
                  child: ListTile(
                    leading: ItemRounded(image: 'assets/images/santi.jpeg'),
                    title: Text(
                      'Member 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Bagian: Admin',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
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
    Key? key,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    double size_width = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: size_width * 0.015),
        child: Container(
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
         );
  }
}
