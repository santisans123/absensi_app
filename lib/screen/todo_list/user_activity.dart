import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/api/api_provider.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date/date_picker_project.dart';
import 'package:spo_balaesang/screen/todo_list/buttonbar_todo_list.dart';
import 'package:spo_balaesang/screen/todo_list/list_done.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class UserActivity extends StatefulWidget {
  UserActivity({Key key, this.id_project}) : super(key: key);

  final int id_project;

  @override
  _UserActivityState createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  User user;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  bool isChecked = false;
  bool isChecked2 = false;

  final ApiProvider apiProvider = Get.find();
  var dataMember = [];

  void _loadMember() {
    apiProvider.getMember(widget.id_project).then((response) {
      final data = response.body;
      print("data api: ${response.body}");
      print("data status: ${response.statusCode}");
      setState(() {
        var todo = data['data'] as List<dynamic>;
        dataMember = todo;
      });
    });
  }

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

  List<Widget> listMember() {
    return dataMember
        .map(
          (row) => Card(
            elevation: 2.0,
            child: GestureDetector(
              onTap: () {
                Get.to(ListDone());
              },
              child: ListTile(
                leading: ItemRounded(
                    image:
                        "https://ui-avatars.com/api/?name=${row['user']['name'].replaceAll(' ', '+')}&size=248"),
                title: Text(
                  '${row['user']['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Bagian: ${row['user']['position']}',
                  style: TextStyle(color: Colors.black87),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                ),
              ),
            ),
          ),
        )
        .toList();
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
    _loadMember();
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
      body: Container(
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
              sizedBoxH6,
              Expanded(child: ListView(
                children: listMember(),
              ))
            ],
          ),
        ),
    );
  }
}

class ItemRounded extends StatelessWidget {
  ItemRounded({
    this.image,
    Key key,
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
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
