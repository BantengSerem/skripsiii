import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();
  final HomeVM pageVM = Get.put(HomeVM());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  // alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: pageVM.searchBarTextController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () {
                      pageVM.openSeachBar();
                    },
                    autofillHints: const ['nasi padang', 'burger', 'soto ayam'],
                    onTapOutside: (_) {
                      pageVM.closeSearchbar();
                      FocusScope.of(context).unfocus();
                    },
                    onSubmitted: (submitted) {
                      pageVM.closeSearchbar();
                    },
                    enableSuggestions: true,
                  ),
                ),
                Obx(
                  () => pageVM.searchBarOpen.value
                      ? Container(
                          height: 100,
                          color: Colors.red,
                        )
                      : Container(
                          color: Colors.red,
                          // margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Selling Now'),
                                    Text('View All'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 20,
                                  itemBuilder: (context, idx) => Container(
                                    height: 30,
                                    width: 60,
                                    color: Colors.greenAccent,
                                    margin: const EdgeInsets.all(5),
                                    child: Text('item $idx'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeVM extends GetxController {
  RxBool searchBarOpen = false.obs;
  final TextEditingController searchBarTextController = TextEditingController();

  void openSeachBar() {
    searchBarOpen.value = true;
  }

  void closeSearchbar() {
    searchBarOpen.value = false;
  }
}
