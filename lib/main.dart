import 'package:adcom/src/app.dart';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setAppId("ea109547-8715-4fc2-aa63-f9afe45349b0");

  OneSignal.shared
      .getDeviceState()
      .then((value) => {print('${value!.userId}')});

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  /* OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  }); */
  runApp(MyApp());
}
