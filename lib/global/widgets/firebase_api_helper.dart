import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApiHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  initPart() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    LoggerUtil()
        .errorData('User granted permission: ${settings.authorizationStatus}');

    String fbToken = await messaging.getToken() ?? '';
    LoggerUtil().errorData("FbToken :- $fbToken");

    
  }
}
