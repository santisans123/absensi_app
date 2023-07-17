import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date/date_picker_project.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class ListDone extends StatefulWidget {
  ListDone({
    Key key,
  }) : super(key: key);

  @override
  _ListDoneState createState() => _ListDoneState();
}

class _ListDoneState extends State<ListDone> {

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
        title: const Text('List Done'),
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
                'Member 1',
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
                  onTap: () {

                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 32.0,
                    ),
                    title: Text(
                      'To Do 1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Membuat Aplikasi SIAP',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Text(
                      '20-07-2023',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
              sizedBoxH6,
              Card(
                elevation: 2.0,
                child: GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 32.0,
                    ),
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