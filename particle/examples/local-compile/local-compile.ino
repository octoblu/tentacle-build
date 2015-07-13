// This #include statement was automatically added by the Spark IDE.
#include "tentacle-particle.h"

/*#define server "tentacle.octoblu.com"
#define port 80*/


IPAddress server(54,186,61,91);
#define port 80

static const char uuid[]  = "ff12c403-04c7-4e63-9073-2e3b1f8e4450";
static const char token[] = "28d2c24dfa0a5289799a345e683d570880a3bc41";

TCPClient conn;

TentacleArduino tentacle;
Pseudopod pseudopod(conn, conn, tentacle);

void setup() {
  Serial.begin(9600);
  Serial.println(F("The Day of the Tentacle has begun!"));
  waitForWifi();
  connectToServer();
}

void loop() {
  if(!WiFi.ready()) {
      Serial.println(F("WiFi wasn't ready. waiting."));
  }

  if (!conn.connected()) {
    conn.stop();
    connectToServer();
  }
  Serial.println(F("In loop."));
  Serial.flush();
  delay(2000);
  readData();

  if(pseudopod.shouldBroadcastPins() ) {
    Serial.println("I should broadcast my pins. But I'm gonna wait.");
    delay(2000);
    delay(pseudopod.getBroadcastInterval());
    size_t configSize = pseudopod.sendConfiguredPins();
    Serial.print(configSize);
    Serial.print(F(" bytes written while broadcasting pins"));
  }
}

void readData() {

  while (conn.available()) {
    Serial.println(F("Received message"));
    Serial.flush();

    if(pseudopod.readMessage() == TentacleMessageTopic_action) {
      pseudopod.sendPins();
    }
  }

}

void waitForWifi() {
    while(!WiFi.ready()) {
        Serial.println(F("Waiting for wifi"));
        delay(200);
    }
    delay(5000);
}

void connectToServer() {
  int connectionAttempts = 0;
  Serial.println(F("Connecting to the server."));
  Serial.flush();

  while(!conn.connect(server, port)) {
    Serial.println(F("Can't connect to the server."));
    Serial.flush();
    conn.stop();
    connectionAttempts++;
  }
  Serial.println(F("Now I'm waiting a second. to be sure"));
  delay(3000);
  size_t authSize = pseudopod.authenticate(uuid, token);
  Serial.print(authSize);
  Serial.println(F(" bytes written for authentication"));

}
