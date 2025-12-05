import 'package:get/get.dart';

class DateFilterController extends GetxController {
  final selectedDate = Rxn<DateTime>();

  void setDate(DateTime? date) {
    selectedDate.value = date;
  }
}
