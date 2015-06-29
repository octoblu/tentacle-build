#include "tentacle-build.h"

TentacleBuild::TentacleBuild() : TentacleArduino(){
};

PseudopodBuild::PseudopodBuild(Stream& input, Print& output, Tentacle& tentacle) : Pseudopod(input, output, tentacle){
};
