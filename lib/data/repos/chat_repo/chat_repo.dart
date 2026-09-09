
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../../api_provider/api_provider.dart';

class ChatRepo extends GetxService {
  ChatRepo({required this.apiProvider});

  final ApiProvider apiProvider;
}
