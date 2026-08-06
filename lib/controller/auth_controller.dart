
  import 'package:get/get_state_manager/src/simple/get_controllers.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../data/repos/auth_repo/auth_repo.dart';

  class AuthController extends GetxController {
    AuthRepo authRepo;
    SharedPreferences sharedPreferences;

    AuthController({required this.authRepo, required this.sharedPreferences,});



  }
