import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/registerController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.lazyPut<MemberController>(() => MemberController(), fenix: true);
    Get.lazyPut<ShopController>(() => ShopController(), fenix: true);
    Get.lazyPut<FoodController>(() => FoodController(), fenix: true);
    Get.lazyPut<RegisterController>(() => RegisterController(), fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(),
        fenix: true);
  }
}


