import 'package:adcom/src/app.dart';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OneSignal.shared.promptUserForPushNotificationPermission();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("ea109547-8715-4fc2-aa63-f9afe45349b0");
  //OneSignal.shared.postNotification();

  OneSignal.shared.addTrigger("prompt_ios", "true");

  

  /*  OneSignal.shared
      .getDeviceState()
      .then((value) => {print('${value!.userId}')}); */


  runApp(MyApp());
}
