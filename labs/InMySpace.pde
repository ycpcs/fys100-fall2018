import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

// The arduino
Arduino arduino;

// Connections for the RGB LED
final int redPin = 5;
final int greenPin = 6;
final int bluePin = 9;

// Connection for analog input from range finder
final int rangeFinderPin = 0; // (Analog input 0)

PFont f;

// System states
enum State {
  COMFORTABLE,
  TOO_CLOSE,
  COOLING_OFF,
}

// Variable to keep track of the current state
State currentState = State.COMFORTABLE; // COMFORTABLE is the initial state

// Variable storing a moving average of the range finder reading
float dist = 0.0;

// Threshold distance
final float THRESHOLD = 40.0;

// Variable counting the number of times draw() has been executed.
// This is useful for generating time-based outputs.
int ticks = 0;

// Counter for how many ticks the system will be in the COOLING_OFF state
// once it is entered.  0 is appopriate if the system is not in the
// COOLING_OFF state.
int coolingOff = 0;

// How many ticks the system stays in the COOLING_OFF state before
// returning to the COMFORTABLE state.
final int COOLING_OFF_TIME = 180;

void setup() {
  size(400, 400);
  
  String[] ports = Arduino.list();
  for (int i = 0; i < ports.length; i++) {
    println("Port " + i + ":\t" + ports[i]);
  }
  
  arduino = new Arduino(this, Arduino.list()[32], 57600);
  
  arduino.pinMode(redPin, Arduino.OUTPUT);
  arduino.pinMode(greenPin, Arduino.OUTPUT);
  arduino.pinMode(bluePin, Arduino.OUTPUT);
  arduino.analogWrite(redPin, 0);
  arduino.analogWrite(greenPin, 0);
  arduino.analogWrite(bluePin, 0);
  
  f = createFont("Helvetica", 16, true);
  textFont(f, 36);
}

void draw() {
  // Update ticks
  ticks++;
  
  // Update the range finder
  updateRangeFinder();
  
  // draw a circle based on the current range finder reading 
  background(211);
  stroke(0);
  fill((int)(255.0-dist), 50, 50);
  ellipse(200, 200, (int)(255-dist), (int)(255-dist));
  
  State nextState;
  
  switch (currentState) {
    case COMFORTABLE:
      nextState = exec_COMFORTABLE();
      break;
    case TOO_CLOSE:
      nextState = exec_TOO_CLOSE();
      break;
    case COOLING_OFF:
      nextState = exec_COOLING_OFF();
      break;
    default:
      throw new IllegalStateException("Unhandled state: " + currentState);
  }
  
  currentState = nextState;
}

void updateRangeFinder() {
  // Here we are smoothing the output of the range finder.
  dist = (0.9 * dist) + (0.1 * arduino.analogRead(rangeFinderPin));
}

State exec_COMFORTABLE() {
  
  // Generate output(s)
  
  // This makes the brightness of the green directly proportional
  // to the distance
  //arduino.analogWrite(greenPin, (int)dist);
  
  // This generates a pulsing effect that is inversely
  // proportional to the distance
  float x = .1;
  float theta = (ticks / (256.0 - dist)) / x;
  float g = ((sin(theta) + 1.0) / 2.0) * 255.0;
  arduino.analogWrite(greenPin, (int)g);
  
  // Determine next state  
  State nextState;
  if (dist > THRESHOLD) {
    // Stay in COMFORTABLE state
    nextState = State.COMFORTABLE;
  } else {
    // Transition to TOO_CLOSE state
    nextState = State.TOO_CLOSE;
    
    // Turn off green
    arduino.analogWrite(greenPin, 0);
  }
  
  return nextState;
}

State exec_TOO_CLOSE() {
  // Generate outputs
  float x = 2.0;
  float theta = ticks / x;
  float r = ((sin(theta) + 1.0) / 2.0) * 255.0;
  arduino.analogWrite(redPin, (int)r);
  
  // Determine next state
  State nextState;
  if (dist <= THRESHOLD) {
    // Stay in TOO_CLOSE state
    nextState = State.TOO_CLOSE;
  } else {
    // Transition to COOLING_OFF state
    nextState = State.COOLING_OFF;
    
    // Turn off red
    arduino.analogWrite(redPin, 0);
    
    // Set initial coolingOff counter value.
    coolingOff = COOLING_OFF_TIME;
  }
  
  return nextState;
}

State exec_COOLING_OFF() {
  // Generate outputs
  
  // The intensity of the blue decays as we get closer
  // to returning to the COMFORTABLE state
  float b = (float)coolingOff / (float)COOLING_OFF_TIME;
  arduino.analogWrite(bluePin, (int)(b * 255.0));
  
  coolingOff--;
  
  // Determine next state
  State nextState;
  if (coolingOff > 0) {
    // Stay in COOLING_OFF state
    nextState = State.COOLING_OFF;
  } else {
    // Transition to COMFORTABLE
    nextState = State.COMFORTABLE;
    
    // Turn off blue
    arduino.analogWrite(bluePin, 0);
  }
  
  return nextState;
}