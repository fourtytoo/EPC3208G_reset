// -*- C++ -*-

#include <stdlib.h>
#include <string.h>
#include <Arduino.h>

// how long after a push the relay should be activated.
#define ACTIVE_LENGTH 5

int ledPin = 13;
int buttonPin = 12;
int relayPin = 11;

void
blinkLED (int times)
{
  int i;
  while (times--)
    {
      digitalWrite(ledPin, HIGH);
      delay(500);
    }
  digitalWrite(ledPin, LOW);
}

void
setup ()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(buttonPin, INPUT);
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW);
  blinkLED(3);
}

int activated = 0;

void
loop ()
{
  int command = 0;

  if (Serial.available() > 0)
    command = Serial.read();
  if (digitalRead(buttonPin) == HIGH || command == 'S')
    {
      activated = ACTIVE_LENGTH;
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
      delay(1000);
    }
}