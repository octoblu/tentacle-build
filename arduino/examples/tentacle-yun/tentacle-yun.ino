#include <Bridge.h>
#include <YunClient.h>

#include "tentacle-build.h"

//Checkout http://tentacle.readme.io for setup and usage instructions

#define server "tentacle.octoblu.com"
#define port 1528

static const char uuid[]  = "INSERT UUID HERE";
static const char token[] = "INSERT TOKEN HERE";

YunClient conn;

TentacleArduino tentacle;
Pseudopod pseudopod(conn, conn, tentacle);

void setup() {
  Serial.begin(9600);
  Serial.println(F("The Day of the Tentacle has begun!"));
  Bridge.begin();
  connectToServer();
}

void loop() {
  if (!conn.connected()) {
    conn.stop();
    connectToServer();
  }

  readData();

  if(pseudopod.shouldBroadcastPins() ) {
    delay(pseudopod.getBroadcastInterval());
    Serial.println(F("Sending pins"));
    pseudopod.sendConfiguredPins();
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

void connectToServer() {
  Serial.println(F("Connecting to the server."));
  Serial.flush();

  while(!conn.connect(server, port)) {
    Serial.println(F("Can't connect to the server."));
    Serial.flush();
    conn.stop();
  }

  size_t authSize = pseudopod.authenticate(uuid, token);
  Serial.print(authSize);
  Serial.println(F(" bytes written for authentication"));

}
