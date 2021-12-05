import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:narrid/core/global.dart';

Future<void> createAppNotification(title, body) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Global().createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.money_money_bag + Emojis.plant_cactus} ${title}',
      body: "${body}",
    ),
  );
}
