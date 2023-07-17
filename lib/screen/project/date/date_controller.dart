import 'package:get/get.dart';

class DateController extends GetxController {
  final dateValue = "".obs;

  void setdate(String date) {
    dateValue(date);
  }

}