#include <fstream>
#include <string>
#include <thread>
#include <chrono>
#include <iostream>
#include <exception>
#include <unistd.h>	// Fuer getuid() und sleep()
#include <wiringPi.h>

// USB,ETHERNET rechts, dann oberste Reihe ganz rechts - Pinposition
#define FAN_PIN 29
#define SLEEP_SECONDS 30
#define TEMP_TO_START_FAN 48

// true = fan on, false = fan off
bool control_fan(bool on){ return !on; }


unsigned int str_to_int(std::string& str){
    unsigned int tmp = 0;
    for (std::size_t i = 0; i < str.size(); i++){
        tmp += str[i] - '0';
        tmp *= 10;
    }
    tmp /= 10;
    return tmp;
}

float getTemperature(std::ifstream& cpu_temp){
	float temperature = 0;
	std::string tmp;
	cpu_temp.seekg(0, std::ios::end);
	cpu_temp.seekg(0, std::ios::beg);
	std::getline(cpu_temp, tmp);
	temperature = str_to_int(tmp);
	temperature /= 1000;
	tmp.clear();
	return temperature;
}

int main(){
	if(getuid() != 0){
                std::cerr << "Muss als root bzw. sudo gestartet werden, da auf GPIO zugegriffen wird\n";
                return -1;
        }
	std::ifstream cpu_temp("/sys/class/thermal/thermal_zone0/temp");
        if(!cpu_temp.good()){
                throw std::runtime_error("Fehler beim oeffnen von /sys/class/thermal/thermal_zone0/temp Datei\n");
        }
	wiringPiSetup();
	pinMode(FAN_PIN, OUTPUT);
	float temperature = 0;
	while(true){
		temperature = getTemperature(cpu_temp);
		if(temperature >= TEMP_TO_START_FAN){
			digitalWrite(FAN_PIN, control_fan(HIGH));
		}else{
			digitalWrite(FAN_PIN, control_fan(LOW));
		}
		std::this_thread::sleep_for(std::chrono::seconds(SLEEP_SECONDS));
	}

	return 0;
}
