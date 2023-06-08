import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsiii/model/shopModel.dart';

class ShopController extends GetxController {
  late Rx<Shop> shop = Shop.blank().obs;
  final fireStoreInstance = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getSellNow() async {
    return fireStoreInstance.collection('shop').where(
          'closingTime',
          isGreaterThanOrEqualTo: DateTime.now(),
        ).get();
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getSellSoon()async{
    return fireStoreInstance.collection('shop').where(
      'closingTime',
      isGreaterThanOrEqualTo: DateTime.now(),
    ).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestedRestaurant(
      String query) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    return await fireStoreInstance
        .collection('shop')
        .where('shopName', isGreaterThanOrEqualTo: query)
        .limit(10)
        .get();
  }
}
