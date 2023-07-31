import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider extends GetConnect {

  Future<Response> login(Map data) => post('/api/login', data);

  Future<Response> postProject(Map data) => post('/api/project-management/insert-project', data);

  Future<Response> editProject(Map data) => post('/api/project-management/update-project', data);

  Future<Response> editTodoPersonal(Map data) => post('/api/todo-list/update-todo-personal', data);

  Future<Response> deleteProject(Map data) => post('/api/project-management/delete-project', data);

  Future<Response> statusDonePersonal(Map data) => post('/api/todo-list/update-status-done', data);

  Future<Response> statusUndonePersonal(Map data) => post('/api/todo-list/update-status-undone', data);

  Future<Response> statusDoneProject(Map data) => post('/api/todo-list/update-status-done-project', data);

  Future<Response> statusUndoneProject(Map data) => post('/api/todo-list/update-status-undone-project', data);

  Future<Response> deleteTodoPersonal(Map data) => post('/api/todo-list/delete-todo-personal', data);

  Future<Response> postMemberProject(Map data) => post('/api/project-management/insert-member', data);

  Future<Response> postTodo(Map data) => post('/api/todo-list/insert-todo-project', data);

  Future<Response> postTodoPersonal(Map data) => post('/api/todo-list/insert-todo-personal', data);

  Future<Response> getProject() => get('/api/project-management/get-project');

  Future<Response> getTodoDonePersonal() => get('/api/todo-list/get-todo-personal-done');

  Future<Response> getTodoDoneByuser(id) => get('/api/todo-list/get-todo-project-done');

  Future<Response> getTodoUndonePersonal() => get('/api/todo-list/get-todo-personal-undone');

  Future<Response> getAllTodo(id) => get('/api/todo-list/get-all-todo-project/$id');

  Future<Response> getMember(id) => get('/api/project-management/get-member/$id');

  Future<Response> getTodoPersonal() => get('/api/todo-list/get-todo-personal');

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