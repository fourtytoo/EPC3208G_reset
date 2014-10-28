// -*- C++ -*-

/* Commands:
   0-5 analog pin value
   S relay status (0=off)
   T toggle relay
*/

#include <stdlib.h>
#include <string.h>
#include <Arduino.h>

// how long after a push the relay should be activated.
#define ACTIVE_LENGTH 10

int relayPin = 8;
int buttonPin = 12;		// digital input
int ledPin = 13;

void
blinkLED (int times, int ms)
{
  while (times--)
    {
      digitalWrite(ledPin, HIGH);
      delay(ms);
      digitalWrite(ledPin, LOW);
      delay(ms);
    }
}

void
setup ()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW);
  blinkLED(5, 200);
}

int activated = 0;

void
loop ()
{
  int command = 0;

  if (Serial.available() > 0)
    command = Serial.read();
  // query analog pin 0-5
  if (command >= '0' && command <= '5')
    Serial.println(analogRead(command - '0'));
  if (command == 'S')
    Serial.println(activated);
  if (digitalRead(buttonPin) == LOW || command == 'T')
    {
      activated = ACTIVE_LENGTH * 1000;
      digitalWrite(relayPin, HIGH); 
      digitalWrite(ledPin, HIGH);
    }
  if (activated > 0)
    {
      activated--;
      if (!activated)
	{
	  digitalWrite(ledPin, LOW);
	  digitalWrite(relayPin, LOW);
	}
      delay(1);
    }
}
