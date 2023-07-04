import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'config.dart';

final client = MqttServerClient(MQTT_HOST, '1883');

void onConnected() {
  print('OnConnected client callback - Client connection was sucessful');
}

void connectMqtt () async{
  client.onConnected = onConnected;
  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('client connected');
  } else {
    print(
        'client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }
}

void sendMqttMessage (String message, String topic) {
  final builder = MqttClientPayloadBuilder();
  print('sending to the topic $topic $message');
  client.subscribe(topic, MqttQos.exactlyOnce);
  builder.addString(message);
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}