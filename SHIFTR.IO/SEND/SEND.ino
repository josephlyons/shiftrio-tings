int val = 0;

#include <WiFi.h>
#include <MQTT.h>

const char ssid[] = "wifi4daboys";
const char pass[] = "Waffles666";

WiFiClient net;
MQTTClient client;

void connect() 
{
  while (WiFi.status() != WL_CONNECTED) {}
  while (!client.connect("send", "90a85098", "a7fed12984960679")) {}
}

void messageReceived(String &topic, String &payload) {
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, pass);
  client.begin("broker.shiftr.io", net);
  client.onMessage(messageReceived);
  connect();
}

void loop() {
if(Serial.available())
  {
  val = Serial.read();
  }
 
client.loop();
delay(10);

if (!client.connected()) 
  {
  connect();
  }
    if(val == 1) //frown
    {
    client.publish("/eyebrows","1"); //frown
    }
      else if(val == 2) //raise
      {
      client.publish("/eyebrows","2"); //raise
      }
        else //neutral
        {
        client.publish("/eyebrows", "0"); //neutral
        }
delay(15);
}
