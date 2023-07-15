import 'dart:convert';
import 'package:spo_balaesang/api/api_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date_picker_project.dart';
import 'package:spo_balaesang/screen/todo_list/personal/todo_list_personal.dart';
import 'package:spo_balaesang/screen/todo_list/todo_list_screen.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late User user;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();

  final ApiProvider apiProvider = Get.find();
  var dataProject = <dynamic>[];

  void _loadData() {
    final url = 'https://siap.sigarda.com/public/api/project-management/get-project';
    DefaultCacheManager().getSingleFile(url).then((file) {
      file.readAsString().then((str) {
        final data = jsonDecode(str);
        setState(() {
          var project = data['data'];
          dataProject = project
              .map((row) => [
            row[0],
            _listProject(
            )
          ]).toList();
        });
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
              final Map<String, dynamic> response =
              await dataRepo.logout();
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
            child: const Text('Ya',
              style: TextStyle(
                color: Colors.blueAccent,
              ),),),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Tidak',
              style: TextStyle(
                color: Colors.blueAccent,
              ),),),
        ],);
    } catch (e) {
      showErrorDialog({
        'message': 'Kesalahan',
        'errors': {
          'exception': ['Terjadi kesalahan!']
        }
      });
    }
  }

  void addProject() {
    final size_width = MediaQuery.of(context).size.width;
    Get.defaultDialog(
      title: 'Tambah Project',
      content: Container(
          padding: EdgeInsets.only(right: size_width * 0.01),
          height: size_width /1.5,
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
          ],)),
      onConfirm: () { Get.back(); },
      onCancel: () {},
    );
  }

  List<Widget> _listProject(){
    return dataProject.map((row) =>
        Card(
          elevation: 2.0,
          child: InkWell(
            onTap: () {
              Get.to(TodoListScreen());
            },
            child: const ListTile(
              leading: Icon(
                Icons.document_scanner,
                color: Colors.purple,
                size: 32.0,
              ),
              title: Text(
                'Project 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Membuat Aplikasi Samawa',
                style: TextStyle(color: Colors.black87),
              ),
              trailing: Text(
                '12-07-2023',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ),
    ).toList();
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
        leading: Image.asset('assets/logo/logo.png'),
        leadingWidth: Get.width * 0.25,
        title: const Text('Project'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shadowColor: Colors.blue,
                elevation: 5.0,
                child: ListTile(
                  leading: const Icon(
                    Icons.folder,
                    color: Colors.indigo,
                    size: 32.0,
                  ),
                  trailing: FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    onPressed: () {
                      addProject();
                    },
                    child: const Icon(Icons.add),
                  ),
                  title: const Text(
                    'Add Project',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Tambahkan Project Anda',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              sizedBoxH12,
              const Text(
                'Project Anda',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.blueAccent,),
              ),
              dividerT1,
              sizedBoxH6,
              ListView(
                children: _listProject()
              ),
              sizedBoxH10,
              Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    Get.to(TodoListScreen());
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.document_scanner,
                      color: Colors.purple,
                      size: 32.0,
                    ),
                    title: Text(
                      'Project 2',
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
              sizedBoxH10,
            ],
          ),
        ),
      ),
    );
  }
}