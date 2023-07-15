import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider extends GetConnect {

  Future<Response> login(Map data) => post('/api/login', data);

  Future<Response> postProject(Map data) => post('/api/project-management/insert-project', data);

  Future<Response> postMemberProject(Map data) => post('/api/project-management/insert-member', data);

  Future<Response> postTodo(Map data) => post('/api/todo-list/insert-todo-project', data);

  Future<Response> getProject() => get('/api/project-management/get-project');

  Future<Response> getAllTodo(id) => get('/api/todo-list/get-all-todo-project/$id');

  Future<Response> getTodoByUser(id) => get('/api/todo-list/get-todo-project');

  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://siap.sigarda.com/public';

    httpClient.addRequestModifier((Request request) {
      if (box.hasData('token')) request.headers['Authorization'] =  "Bearer ${box.read('token')}";
      return request;
    });
  }
}