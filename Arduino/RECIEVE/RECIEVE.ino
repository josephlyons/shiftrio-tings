#include <WiFi.h>
#include <MQTT.h>
#include <Servo_ESP32.h>

Servo_ESP32 servoA;
int Rval = 0;
const char* eyebrows = "/eyebrows";

const char ssid[] = "wifi4daboys";
const char pass[] = "Waffles666";

WiFiClient net;
MQTTClient client;

unsigned long lastMillis = 0;

void connect() {
  while (WiFi.status() != WL_CONNECTED) {}
  while (!client.connect("recieve", "90a85098", "a7fed12984960679")) {}
  client.subscribe("/joe");
  client.subscribe(eyebrows);
  // client.unsubscribe("/joe");
}

void messageReceived(String &topic, String &payload) 
{
  if (topic==eyebrows)
    {
    int Rval = payload.toInt();
    }
}

void setup() 
{
  servoA.attach(14);
  WiFi.begin(ssid, pass);
  client.begin("broker.shiftr.io", net);
  client.onMessage(messageReceived);
  connect();
}

void loop() 
{
  client.loop();
  delay(10);  // <- fixes some issues with WiFi stability

  if (!client.connected()) {
    connect();
  }
  
if (client.connected())
  {
    if(Rval == 1) // frown
    {
      servoA.write(0);
    }
      else if(Rval == 2) //raise
      {
        servoA.write(180);
      }
        else //neutral
        {
          servoA.write(90);
        }
delay(15);
  }
}
