import oscP5.*; //  Load OSC P5 library
import netP5.*; //  Load net P5 library
import mqtt.*;  // Load mqtt library
float eyebrow;
int tempint = 0;

MQTTClient client;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() 
{
size(360, 360); 
client = new MQTTClient(this);
client.connect("mqtt://90a85098:a7fed12984960679@broker.shiftr.io", "processing");
client.publish("/eyebrows", "0");
background(0, 0, 250);

oscP5 = new OscP5(this, 8338);   // Start oscP5, listening for incoming messages at port 8338 
}

void draw() 
{
textSize(40);
if (eyebrow > 9) {}
}

void mousePressed() {}

void oscEvent(OscMessage theOscMessage) 
{
if (theOscMessage.checkAddrPattern("/gesture/eyebrow/left")==true) 
  {
  float firstValue = theOscMessage.get(0).floatValue();
  eyebrow = firstValue; //get osc data for left eyebrow and put it into float "eyebrow"

  float temp = (map(eyebrow, 6, 9, 1, 10)); //map eyebrow height low to high to two values
  int tempint = int(temp); // make this an integer called "tempint"
  String pos = str(tempint); //make this a string "make this a string called "pos"
  }

if (tempint > 3) {
  client.publish("/eyebrows", "0"); //neutral
  background(250, 250, 0);
  rect(170, 25, 25, 300);
  } else if (tempint < 4) {
    client.publish("/eyebrows", "2"); //frown
    background(0, 250, 0);
    rect(150, 25, 25, 300);
    rect(190, 25, 25, 300);
    } else if (tempint > 6) {
      client.publish("/eyebrows", "1"); //raise
      background(0, 0, 250);
      rect(130, 25, 25, 300);
      rect(170, 25, 25, 300);
      rect(210, 25, 25, 300);
      }
delay(15);  
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
