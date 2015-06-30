#include "tentacle-build.h"

Noodle::Noodle() : TentacleArduino(){
};

FakeFoot::FakeFoot(Stream& input, Print& output, Tentacle& tentacle) : Pseudopod(input, output, tentacle){
};
