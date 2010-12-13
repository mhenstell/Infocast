#include <SPI.h>
#include <X10Firecracker.h>
#include <Client.h>    // textFinder needs the class definitions in this file
#include <TextFinder.h>

TextFinder  finder(Serial);  

const int NUMBER_OF_FIELDS = 3; // how many comma seperated fields we expect                                           
int values[NUMBER_OF_FIELDS];   // array holding values for all the fields

char val;
String data;
String dataold;

void setup()
{
  X10.init( 2, 3, 1 );
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  Serial.print("Hello world.");
}


void Test()
{
  digitalWrite(13, HIGH);
  X10.sendCmd( hcA, 1, cmdOn );
  delay(1000);
  digitalWrite(13, LOW);
  X10.sendCmd( hcA, 1, cmdOff );
}



void loop()
{
  int fieldIndex = 0;            // the current field being received
  finder.find("X");   
  while(fieldIndex < NUMBER_OF_FIELDS)
    values[fieldIndex++] = finder.getValue();      
  Serial.println("All fields received:");
  for(fieldIndex=0; fieldIndex < NUMBER_OF_FIELDS; fieldIndex++)
    Serial.println(values[fieldIndex]);
  
  
  sendX10(values[0], values[1], values[2]);
}

void sendX10(int h, int d, int c) {
  HouseCode hc;
  CommandCode cmd;
  
 switch (h) {
  case 1:
    hc = hcA;
    Serial.println("House A");
    break;
 }
 
 switch (c) {
   case 1:
     cmd = cmdOn;
     Serial.print("CmdOn");
     break;
   case 2:
     cmd = cmdOff;
     Serial.print("CmdOff");
     break;
   case 3:
     cmd = cmdBright;
     break;
   case 4:
     cmd = cmdDim;
     break;
 }
 
 Serial.print("Device: " + d);
 
 X10.sendCmd(hc, d, cmd);
}
