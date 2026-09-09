import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repos/chat_repo/chat_repo.dart';

class ChatController extends GetxController {
  ChatController({
    required this.chatRepo,
    required this.sharedPreferences,
  });

  final ChatRepo chatRepo;
  final SharedPreferences sharedPreferences;

}
