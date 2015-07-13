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
  debugPhoton();
  connectToServer();
}

void loop() {
  if (!conn.connected()) {
    conn.stop();
    connectToServer();
  }
  Serial.println(F("In loop."));
  Serial.flush();
  delay(2000);
  readData();

  if(pseudopod.shouldBroadcastPins() ) {
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

void connectToServer() {
  Serial.println(F("Connecting to the server."));
  Serial.flush();

  while(!conn.connect(server, port)) {
    Serial.println(F("Can't connect to the server."));
    Serial.flush();
    conn.stop();
    delay(500);
  }

  size_t authSize = pseudopod.authenticate(uuid, token);
  Serial.print(authSize);
  Serial.println(F(" bytes written for authentication"));
}

void debugPhoton() {
  Serial.println(F("Waiting for slow humans."));
  delay(2000);

  Serial.println(F("\n\nDebugging PHOTON"));

  Serial.print(F("\nWiFi Ready:\t"));
  Serial.println(WiFi.ready());

  if (WiFi.ready()) {
      Serial.println(F("WiFI:\t\t\t ready"));
  } else {
    Serial.println(F("WiFI:\t\t\t NOT ready"));
  }

  if (Spark.connected()) {
      Serial.println(F("Spark Cloud:\t\t\t connected"));
  } else {
    Serial.println(F("Spark Cloud:\t\t\t NOT Connected"));
  }

  Serial.println(F("\nPinging google"));
  Serial.println(WiFi.ping(IPAddress(74,125,239,34)));

  Serial.println(F("Pinging Tentacle"));
  Serial.println(WiFi.ping(IPAddress(54,186,61,91)));

  Serial.println(WiFi.localIP());
  Serial.println(WiFi.subnetMask());
  Serial.println(WiFi.gatewayIP());
  Serial.println(WiFi.SSID());
  
}
