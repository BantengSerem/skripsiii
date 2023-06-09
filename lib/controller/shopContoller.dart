import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsiii/model/shopModel.dart';

class ShopController extends GetxController {
  late Rx<Shop> shop = Shop.blank().obs;
  final fireStoreInstance = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getSellNow() async {
    return fireStoreInstance
        .collection('shop')
        .where(
          'closingTime',
          isGreaterThanOrEqualTo: DateTime.now(),
        )
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSellSoon() async {
    return fireStoreInstance
        .collection('shop')
        .where(
          'closingTime',
          isGreaterThanOrEqualTo: DateTime.now(),
        )
        .get();
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

// On progress, don't change
  Map<String, double> getLatLongRange({double radius = 1}) {
    // double latRange = radius / 6371.0 * (180 / pi);
    // double lonRange =
    //     radius / (6371.0 * cos(latitude * pi / 180)) * (180 / pi);
    return {};
  }

  Map<String, double> getLatLongFilter({
    double latRange = 0.009,
    double lonRange = 0.014,
    required double latitude,
    required double longitude,
  }) {
    double minLat = latitude - latRange;
    double maxLat = latitude + latRange;
    double minLon = longitude - lonRange;
    double maxLon = longitude + lonRange;

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLon': minLon,
      'maxLon': maxLon,
    };
  }
}
