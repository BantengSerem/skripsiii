import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.lazyPut<MemberController>(() => MemberController(), fenix: true);
    Get.lazyPut<ShopController>(() => ShopController(), fenix: true);
  }
}

// class AppPages {
//   static final pages = [
//     GetPage(name: '/', page: () => HomePage(), bindings: [
//
//     ]),
//   ];
// }
