#include <SPI.h>
#include <WiFi.h>

//Checkout http://tentacle.readme.io for setup and usage instructions
//Warning: If you are using the official Arduino wifi shield, not defining this variable may produce corrupted data.
//Defining it, however, slows things down quite a bit.
#define MIN_DELAY 2000

#include "tentacle-build.h"

//octoblu hq
char ssid[] = "INSERT WIFI NAME HERE";
char password[] = "INSERT WIFI PASSWORD HERE";
#define server "tentacle.octoblu.com"
/*#include "wifi-credentials.h"*/
#define port 1528

static const char uuid[]  = "INSERT UUID HERE";
static const char token[] = "INSERT TOKEN HERE";

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
