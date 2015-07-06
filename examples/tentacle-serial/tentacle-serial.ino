#include <SPI.h>

#include "tentacle-build.h"


static const char uuid[]  = "ff12c403-04c7-4e63-9073-2e3b1f8e4450";
static const char token[] = "28d2c24dfa0a5289799a345e683d570880a3bc41";

#define conn Serial

TentacleArduino tentacle;
Pseudopod pseudopod(conn, conn, tentacle);

void setup() {
  Serial.begin(57600);
  connectToServer();
}

void loop() {
  readData();
  if(pseudopod.shouldBroadcastPins() ) {
    delay(pseudopod.getBroadcastInterval());  
    pseudopod.sendConfiguredPins();
  }
}

void readData() {

  while (conn.available()) {
    if(pseudopod.readMessage() == TentacleMessageTopic_action) {
      pseudopod.sendPins();
    }
  }

}

void connectToServer() {
  size_t authSize = pseudopod.authenticate(uuid, token);
}
