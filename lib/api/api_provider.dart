import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider extends GetConnect {
  Future<Response> login(Map data) => post('/api/login', data);

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