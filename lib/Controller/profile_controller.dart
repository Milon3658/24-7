import 'package:get/get.dart';

import '../../Data/Models/profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController to = Get.find();
  var profile = Rx<ProfileModel?>(null);
}
