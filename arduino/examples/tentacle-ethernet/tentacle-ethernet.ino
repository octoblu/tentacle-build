#include <SPI.h>
#include <Ethernet.h>

#include "tentacle-build.h"

#define DELAY 2000

//Checkout http://tentacle.readme.io for setup and usage instructions
// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {
  0x00, 0xAA, 0xBB, 0xCC, 0xDE, 0x02
};

#define server "tentacle.octoblu.com"
#define port 1528

static const char uuid[]  = "INSERT UUID HERE";
static const char token[] = "INSERT TOKEN HERE";

EthernetClient conn;

TentacleArduino tentacle;
Pseudopod pseudopod(conn, conn, tentacle);

void setup() {
  Serial.begin(9600);
  Serial.println(F("The Day of the Tentacle has begun!"));

  setupEthernet();
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
    connectionAttempts++;
  }

  size_t authSize = pseudopod.authenticate(uuid, token);
  Serial.print(authSize);
  Serial.println(F(" bytes written for authentication"));

}

void setupEthernet() {
  while (Ethernet.begin(mac) == 0) {
    Serial.print(F("DHCP failed. Trying again."));
    Serial.flush();
  }

  // print your Ethernet shield's IP address:
  IPAddress ip = Ethernet.localIP();
  Serial.print(F("IP Address: "));
  Serial.println(ip);

  Serial.flush();
}

void softReset() {
  asm volatile ("  jmp 0");
}
