#include "tentacle-arduino/tentacle-arduino.h"
#include "tentacle-pseudopod/tentacle-pseudopod.h"

class Noodle : public TentacleArduino {
  public:
    Noodle();
};

class FakeFoot : public Pseudopod {
  public:
    FakeFoot(Stream& input, Print& output, Tentacle& tentacle);
};
