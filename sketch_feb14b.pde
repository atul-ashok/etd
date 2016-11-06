/* -Code to run the prototype of Emergency Traffic Dispersion- */

#include <NewSoftSerial.h>  // Software serial library - Emulates an additional serial port.

NewSoftSerial mySerial(2, 3);  // Setting Receiver & Transmission pins. Rx = 2 | Tx = 3

const int dataPin = 10;  // Pin connected to Pin 12 of 74HC595 (data)
const int latchPin  = 11;  // Pin connected to Pin 14 of 74HC595 (latch)
const int clockPin = 12;  // Pin connected to Pin 11 of 74HC595 (Clock)



char a;  // Variable to store the data receieved from RF antenna
char b;  // Varialble to store the data receieved from RFID
char p1[]={ '0','6','0','1','3','2','4','8' } ;  // RFID tag identity number

int flag1 ; // Variable to increment the position of the RFID tag number for comparision
char mychar = 'z';  // Setting "Z" as trigger to receive from RFID.



void setup()
{
  Serial.begin(9600);  // Serial communication for RF set at the baudrate of 9600
  mySerial.begin(9600);  // Serial communication for RFID set at the baudrate of 9600

  flag1=0;

  pinMode(dataPin , OUTPUT);
  pinMode(latchPin , OUTPUT);
  pinMode(clockPin , OUTPUT);

 

  int pins[] = { 4, 5, 6, 7, 8, 9, 14, 15 };  // For traffic LEDs of four routes

  for(int i=0 ; i<=8 ; i++)
    {
      pinMode(pins[i],OUTPUT);
    }

}



void loop()
{
  Serial.println("loop start");

  digitalWrite(latchPin, LOW); // 7-Segment display is set to LOW initially
  shiftOut(dataPin, clockPin, MSBFIRST, B11111111 );  // Shift out the bits to display '0'
  digitalWrite(latchPin, HIGH); 

loopstart:

  if(Serial.available()>7)
    {
      Serial.println("Serially available");
      b=Serial.read();
      Serial.println(b);

      if(b == 'z')
        {                       // Code for emergency sequence. Setting all red LEDs to HIGH
          digitalWrite(14,HIGH);
          digitalWrite(5,HIGH);
          digitalWrite(7,HIGH);
          digitalWrite(9,HIGH);
    
          digitalWrite(15,LOW);
          digitalWrite(4,LOW);
          digitalWrite(6,LOW);
          digitalWrite(8,LOW);   

          Serial.println("Emergency"); // To displaying "E" on 7-Segment to indicate Emergency

          digitalWrite(latchPin, LOW);  // Make the latch pin LOW to listen for the incoming data
          shiftOut(dataPin, clockPin, MSBFIRST, B10000110 );  // Displaying "E"
          digitalWrite(latchPin, HIGH);  // Make the latch pin HIGH so the LEDs will light up:
    
       delay(10);
       Serial.flush();
                                    // Check the "myserial" port continuously till it recieves the data

      
checkagain:

      if(mySerial.available()>1)   // Check if any data is available from the RFID
        { delay(500);
          for(int i=0;i<8;i++) // For reading data
            {
              a=mySerial.read();
              Serial.println(a);

              if(p1[i]==a)
               {
                 flag1++;
               }           
              delay(10);
             }                // Reading 8 characters is complete
        delay(100);

          if(flag1==8)        // Checking if it is ERV
            { 
              Serial.println("ok");
              digitalWrite(latchPin, LOW);
              shiftOut(dataPin, clockPin, MSBFIRST, B11111111 );  // Shift out the bits to display '0'
              digitalWrite(latchPin, HIGH); 
              delay(100);
            }

          else
            goto checkagain;
        }                     
            else         
            goto checkagain ; 
  
        }         
    }
  flag1 = 0;
  Serial.flush();
    
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, B11111111 );  // Shift out the bits to display '0'
  digitalWrite(latchPin, HIGH); 


  Serial.println("route1");
  route_one();

  for(int k=0 ; k<100 ; k++)
    {
      if(Serial.available()>7)
        {
          goto loopstart ;
        }
      delay(100);
    }
    
  Serial.println("route2");
  route_two();

  for(int k=0 ; k<100 ; k++)
    {
      if(Serial.available()>7)
        {
          goto loopstart ;
        }
      delay(100);
    }


  Serial.println("route3");
  route_three();

  for(int k=0 ; k<100 ; k++)
    {
      if(Serial.available()>7)
        {
          goto loopstart ;
        }
      delay(100);
    }


  Serial.println("route4");
  route_four();

  for(int k=0 ; k<100 ; k++)
    {
      if(Serial.available()>7)
        {
          goto loopstart ;
        }
      delay(100);
    }

  Serial.println("endofloop");

 
}                             // End of void loop

void Emergency()  // Emergency (display showing 'E' )
  {
    digitalWrite(14,HIGH);
    digitalWrite(5,HIGH);
    digitalWrite(7,HIGH);
    digitalWrite(9,HIGH);
  
    digitalWrite(15,LOW);
    digitalWrite(4,LOW);
    digitalWrite(6,LOW);
    digitalWrite(8,LOW);
  }


void route_one() // Traffic light function for Route 1
  {
    if(Serial.available()>7)
      {
         loop() ;
      }
    digitalWrite(14,HIGH);
    digitalWrite(5,HIGH);
    digitalWrite(7,HIGH);
    digitalWrite(9,HIGH);
  
    digitalWrite(15,LOW);
    digitalWrite(4,LOW);
    digitalWrite(6,LOW);
    digitalWrite(8,LOW);
  }


void route_two() // Traffic light function for Route 2
  {
    if(Serial.available()>7)
      {
        loop() ;
      }
    digitalWrite(15,HIGH);
    digitalWrite(4,HIGH);
    digitalWrite(7,HIGH);
    digitalWrite(9,HIGH);
  
    digitalWrite(14,LOW);
    digitalWrite(5,LOW);
    digitalWrite(6,LOW);
    digitalWrite(8,LOW);
  }


void route_three() // Traffic light function for Route 3
  {
    if(Serial.available()>7)
      {
        loop() ;
      }
      digitalWrite(15,HIGH);
      digitalWrite(5,HIGH);
      digitalWrite(6,HIGH);
      digitalWrite(9,HIGH);
    
      digitalWrite(14,LOW);
      digitalWrite(4,LOW);
      digitalWrite(7,LOW);
      digitalWrite(8,LOW);
  }


void route_four() // Traffic light function for Route 4
  {
    if(Serial.available()>7)
      {
        loop() ;
      }
    digitalWrite(15,HIGH);
    digitalWrite(5,HIGH);
    digitalWrite(7,HIGH);
    digitalWrite(8,HIGH);
  
    digitalWrite(14,LOW);
    digitalWrite(4,LOW);
    digitalWrite(6,LOW);
    digitalWrite(9,LOW);  
  }






