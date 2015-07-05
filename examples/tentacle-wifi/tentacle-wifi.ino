#include <SPI.h>
#include <WiFi.h>
#define MIN_DELAY 2000

#include "tentacle-build.h"

//octoblu hq
char ssid[] = "octoblu-guest";
char password[] = "octoblu1";
#define server "tentacle.octoblu.com"
/*#include "wifi-credentials.h"*/
#define port 80

static const char uuid[]  = "ff12c403-04c7-4e63-9073-2e3b1f8e4450";
static const char token[] = "28d2c24dfa0a5289799a345e683d570880a3bc41";

int status = WL_IDLE_STATUS;
WiFiClient conn;

TentacleArduino tentacle;
Pseudopod pseudopod(conn, conn, tentacle);

void delayIfNeeded() {
#ifdef MIN_DELAY
delay(MIN_DELAY);
#endif
}

void delayTheAppropriateTime() {
  #ifdef MIN_DELAY
  if(pseudopod.getBroadcastInterval() < MIN_DELAY) {
    delay(MIN_DELAY);
  } else {
    delay(pseudopod.getBroadcastInterval());
  }
  #else
  delay(pseudopod.getBroadcastInterval());
  #endif
}

void setup() {
  Serial.begin(9600);
  Serial.println(F("The Day of the Tentacle has begun!"));

  setupWifi();
  connectToServer();
  delayIfNeeded();
}

void loop() {
  if (!conn.connected()) {
    conn.stop();
    connectToServer();
  }

  readData();
  if(pseudopod.shouldBroadcastPins() ) {
    delayTheAppropriateTime();
    Serial.println(F("Sending pins"));
    pseudopod.sendConfiguredPins();
  }
}

void readData() {
  delayIfNeeded();

  while (conn.available()) {
    Serial.println(F("Received message"));
    Serial.flush();

    if(pseudopod.readMessage() == TentacleMessageTopic_action) {
      delayIfNeeded();
      pseudopod.sendPins();
    }
  }

  delayIfNeeded();
}

void connectToServer() {
  int connectionAttempts = 0;
  Serial.println(F("Connecting to the server."));
  Serial.flush();

  while(!conn.connect(server, port)) {
    if(connectionAttempts > 5) {
      Serial.println(F("Still can't connect. I must have gone crazy. Rebooting"));
      Serial.flush();

      softReset();
    }
    Serial.println(F("Can't connect to the server."));
    Serial.flush();
    conn.stop();
    delayIfNeeded();
    connectionAttempts++;
  }

  size_t authSize = pseudopod.authenticate(uuid, token);
  Serial.print(authSize);
  Serial.println(F(" bytes written for authentication"));

}

void setupWifi() {
  int status = WL_IDLE_STATUS;

  while (status != WL_CONNECTED) {
    Serial.print(F("Attempting to connect to SSID: "));
    Serial.println(ssid);
    Serial.flush();
    status = WiFi.begin(ssid, password);
  }

  // print the SSID of the network you're attached to:
  Serial.print(F("SSID: "));
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print(F("IP Address: "));
  Serial.println(ip);

  Serial.flush();
}

void softReset() {
  asm volatile ("  jmp 0");
}
