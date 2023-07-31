import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_balaesang/api/api_provider.dart';
import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/repositories/data_repository.dart';
import 'package:spo_balaesang/screen/login_page.dart';
import 'package:spo_balaesang/screen/project/date/date_controller.dart';
import 'package:spo_balaesang/screen/project/date/date_picker_project.dart';
import 'package:spo_balaesang/screen/todo_list/buttonbar_todo_list.dart';
import 'package:spo_balaesang/screen/todo_list/user_activity.dart';
import 'package:spo_balaesang/utils/app_const.dart';
import 'package:spo_balaesang/utils/view_util.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({
    Key key,
    this.id_project
  }) : super(key: key);

  final int id_project;

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  User user;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  bool isChecked = false;
  final box = GetStorage();
  final DateController dateController = Get.find();

  var dataTodo = [];
  var dataMember = [];

  final ApiProvider apiProvider = Get.find();

  void _loadData() {
    apiProvider.getAllTodo(widget.id_project).then((response) {
      final data = response.body;
      print('project_id: ${widget.id_project}');
      // print("data api: ${response.body}");
      // print("data status: ${response.statusCode}");
      setState(() {
        var todo = data['data'] as List<dynamic> ;
        dataTodo = todo;
      });
    });
  }

  void submitMember(int project_id, int index) {
    print("index : ${index}");
    apiProvider.postMemberProject({
      'project_id': project_id,
      'members[${index}]': deskripsiController.text,
    }).then((response) {
      print('date: ${dateController.dateValue.value}');
      print('response ${response.body}');
      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        _loadData();
        Get.back();
      } else {
        Get.snackbar(
            'Info', 'Gagal membuat project. Periksa kembali semua isian data');
      }
    });
  }


  void statusDone(String id) {
    apiProvider.statusDoneProject({
      'id': int.parse(id),
    }).then((response) {
      print('response ${response.body}');
      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        _loadData();
      } else {
        Get.snackbar('Info', 'Gagal ceklis to do list.');
      }
    });
  }

  void statusUndone(String id) {
    apiProvider.statusUndoneProject({
      'id': int.parse(id),
    }).then((response) {
      print('response ${response.body}');
      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        _loadData();
      } else {
        Get.snackbar('Info', 'Gagal un ceklis to do list.');
      }
    });
  }

  void _loadMember() {
    apiProvider.getMember(widget.id_project).then((response) {
      final data = response.body;
      // print("data api: ${response.body}");
      // print("data status: ${response.statusCode}");
      setState(() {
        var todo = data['data'] as List<dynamic> ;
        dataMember = todo;
      });
    });
  }

  void submit(){
    apiProvider.postTodo({
      'project_id' : widget.id_project,
      'user_id' : box.read('user_id'),
      'title': judulController.text,
      'description': deskripsiController.text,
      'deadline': dateController.dateValue.value,
    }).then((response) {
      print('date: ${dateController.dateValue.value}');
      print('response ${response.body}');
      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        Get.back();
      } else {
        Get.snackbar('Info',
            'Gagal membuat to do list. Periksa kembali semua isian data');
      }
    });
  }

  List<Widget> listMember(){
    return dataMember.map((row) =>
        ItemRounded(
            title: '${row['user']['name']}', image: "https://ui-avatars.com/api/?name=${row['user']['name'].replaceAll(' ', '+')}&size=248"
            .toString()),
      ).toList();
  }

  List<Widget> listTodo(){
    return dataTodo.map((row) => Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: Checkbox(
              value: row['title'] == 1 ? true : false,
              onChanged: (bool newValue) {
                setState(() {
                  row['status'] == 0 ? statusDone('${row['id']}') : statusUndone('${row['id']}');
                });
              }),
          title: Text(
            '${row['title']}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${row['description']}',
            style: TextStyle(color: Colors.black87),
          ),
          trailing: GestureDetector(
            child: Icon(
              Icons.delete,
            ),
            onTap: () {

            },
          ),
        ),
      ),
    )).toList();
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
        submit();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void addMember() {
    final size_width = MediaQuery.of(context).size.width;
    Get.defaultDialog(
      title: 'Tambah Anggota Tim',
      content: Container(
          padding: EdgeInsets.only(right: size_width * 0.01),
          height: size_width / 1.5,
          width: double.maxFinite,
          child: Wrap(
            children: dataMember.map((row) =>
                ItemRounded(
                    title: '${row['user']['name']}',
                    image: "https://ui-avatars.com/api/?name=${row['user']['name'].replaceAll(' ', '+')}&size=248"
                    .toString()),
            ).toList(),
          )),
      onConfirm: () {
        dataMember.map((row) =>
        submitMember(
            int.parse('${row['user']['id']}'),
            dataMember.indexOf(dataMember)
        ));
        _loadData();
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
    _loadData();
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
        title: const Text('To Do List'),
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Tim',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                ),
              ),
              dividerT1,
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.blueAccent,
                      onPressed: () {
                        addMember();
                      },
                      child: const Icon(Icons.add),
                    ),
                    Row(
                      children: listMember()
                    )
                  ]),
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
                    children: listTodo(),
                  )
              ))
            ],
          ),
      ),
      bottomNavigationBar: BottonbarTodolist(
        done: () {},
        todo: () {},
        activity: () {
          Get.to(UserActivity(id_project: widget.id_project,));
        },
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
                  image: NetworkImage(image),
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