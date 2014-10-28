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
#define BLINK_SPEED 300

int relayPin = 8;
int buttonPin = 12;		// digital input
int ledPin = 13;

static void
togglePin (int pin)
{
  digitalWrite(pin, !digitalRead(pin));
}

static void
blinkLED (int times, int ms)
{
  times *= 2;
  ms /= 2;
  digitalWrite(ledPin, LOW);
  while (times--)
    {
      togglePin(ledPin);
      delay(ms);
    }
  digitalWrite(ledPin, LOW);
}

static int
isButtonPressed ()
{
  return digitalRead(buttonPin) == LOW;
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
  blinkLED(ACTIVE_LENGTH, BLINK_SPEED / 2);
}

static int relayOn = 0;

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
    Serial.println(relayOn);
  if (isButtonPressed() || command == 'T')
    {
      relayOn = ACTIVE_LENGTH * 1000;
      digitalWrite(relayPin, HIGH); 
      digitalWrite(ledPin, HIGH);
    }
  if (relayOn)
    {
      relayOn--;
      if (relayOn % BLINK_SPEED == 0)
	togglePin(ledPin);	// blink the LED
      if (!relayOn)
	{
	  digitalWrite(ledPin, LOW);
	  digitalWrite(relayPin, LOW);
	}
      delay(1);
    }
}
