import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/api/api_provider.dart';
import 'package:spo_balaesang/screen/project/date/date_controller.dart';
import 'package:intl/intl.dart';
import 'package:spo_balaesang/screen/todo_list/components/card_done.dart';
import 'package:spo_balaesang/screen/todo_list/personal/buttonbar_personal.dart';
import 'package:spo_balaesang/screen/todo_list/user_activity.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class ListDonePersonal extends StatefulWidget {
  ListDonePersonal({
    Key key,
  }) : super(key: key);

  @override
  _ListDonePersonalState createState() => _ListDonePersonalState();
}

class _ListDonePersonalState extends State<ListDonePersonal> {

  final formatterDate = DateFormat('dd-MM-yyyy kk:mm');

  final DateController dateController = Get.find();

  var dataTodo = [];

  final ApiProvider apiProvider = Get.find();

  void _loadData() {
    apiProvider.getTodoDonePersonal().then((response) {
      final data = response.body;
      print("data api: ${response.body}");
      print("data status: ${response.statusCode}");
      setState(() {
        var todo = data['data'] as List<dynamic>;
        dataTodo = todo;
      });
    });
  }

  List<Widget> listTodoDone() {
    return dataTodo
        .map((row) => CardDone(
      title: '${row['title']}',
      description: '${row['description']}',
      date:  formatterDate
          .format(DateTime.parse('${row['updated_at']}').toLocal()),
    )
    )
        .toList();
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

  @override
  void setState(void Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('List Done'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            sizedBoxH10,
            dividerT1,
            sizedBoxH10,
            Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      setState(() {
                        _loadData();
                      });
                    },
                    child: ListView(
                      children: listTodoDone(),
                    ))),
          ],
        ),
      ),
    );
  }
}

class ItemRounded extends StatelessWidget {
  ItemRounded({
    this.image,
    this.title,
    Key key,
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
