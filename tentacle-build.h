#include "tentacle-arduino/tentacle-arduino.h"
#include "tentacle-pseudopod/tentacle-pseudopod.h"

class TentacleBuild : public TentacleArduino {
  public:
    TentacleBuild();

};
class PseudopodBuild : public Pseudopod {
  public:
    PseudopodBuild(Stream& input, Print& output, Tentacle& tentacle);
};
