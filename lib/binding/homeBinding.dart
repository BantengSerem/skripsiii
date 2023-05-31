import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/view/homePage.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.put<LoginController>(LoginController(), permanent: true);
  }
}

// class AppPages {
//   static final pages = [
//     GetPage(name: '/', page: () => HomePage(), bindings: [
//
//     ]),
//   ];
// }
