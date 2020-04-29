import oscP5.*; //  Load OSC P5 library
import netP5.*; //  Load net P5 library
import mqtt.*;  // Load mqtt library
float eyebrow;

MQTTClient client;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() 
{
size(360, 360); 
frameRate(5);
client = new MQTTClient(this);
client.connect("mqtt://90a85098:a7fed12984960679@broker.shiftr.io", "processing via FaceOSC");
client.publish("/eyebrows", "0");
background(0, 0, 250);

oscP5 = new OscP5(this, 8338);   // Start oscP5, listening for incoming messages at port 8338 
}

void draw() {
}

void mousePressed() {}

void oscEvent(OscMessage theOscMessage) 
{
if (theOscMessage.checkAddrPattern("/gesture/eyebrow/left")==true) 
  {
  float firstValue = theOscMessage.get(0).floatValue();
  eyebrow = firstValue; //get osc data for left eyebrow and put it into float "eyebrow"

  if (eyebrow > 7.3 && eyebrow < 8.5){  //anywhere from 7.001 to 8.49
    client.publish("/eyebrows", "0"); //neutral
    background(250, 250, 0);
    rect(170, 25, 25, 300);
    } else if (eyebrow < 7.3) { // below 7
      client.publish("/eyebrows", "2"); //frown
      background(0, 250, 0);
      rect(150, 25, 25, 300);
      rect(190, 25, 25, 300);
      } else if (eyebrow > 8.5) { //above 8.5
        client.publish("/eyebrows", "1"); //raise
        background(0, 0, 250);
        rect(130, 25, 25, 300);
        rect(170, 25, 25, 300);
        rect(210, 25, 25, 300);
        }
delay(15);
  }
}
  
void clientConnected() {
  println("client connected");

  client.subscribe("/hello");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}

void connectionLost() {
  println("connection lost");
}
