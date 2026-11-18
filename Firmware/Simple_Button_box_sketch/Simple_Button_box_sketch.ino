#include <Joystick.h>

Joystick_ Joystick;
// Matrix Setup
const int numRows = 3;
const int numCols = 3;

int rowPins[numRows] = {2, 3, 4};
int colPins[numCols] = {5, 6, 7};

int buttonState[numRows][numCols];

//Debounce setup
unsigned long lastDebounceTime[numRows][numCols];
int debounceDelay = 20;

// Toggle Switch Setup
int sw1_up = 9;
int sw1_down = 10;
int sw2_up = 14;
int sw2_down = 15;

void setup() {
  Joystick.begin(false);

  // Sets row wires as OUTPUTS and set HIGH to block current
  for (int r = 0; r < numRows; r++) {
    pinMode(rowPins[r], OUTPUT);
    digitalWrite(rowPins[r], HIGH);
  }

  //Set up column wires as INPUTS
  for (int c = 0; c < numCols; c++) {
    pinMode(colPins[c], INPUT_PULLUP);
  }
  //Toggle switch pins setup
  pinMode(sw1_up, INPUT_PULLUP);
  pinMode(sw1_down, INPUT_PULLUP);
  pinMode(sw2_up, INPUT_PULLUP);
  pinMode(sw2_down, INPUT_PULLUP);
}

void loop() {
  // SCAN  MATRIX
  // Determines row:
  for (int r = 0; r < numRows; r++) {
    digitalWrite(rowPins[r], LOW);
    for(int c = 0; c < numCols; c++) {
      int reading = digitalRead(colPins[c]);

      //Assign our 9 buttons values 0-8 based on position
      int buttonNumber = (r * numCols) + c;

      if (reading != buttonState[r][c] &&  (millis() - lastDebounceTime[r][c] > debounceDelay)) {

        buttonState[r][c] = reading; //save the button's state to our 2D grid
        lastDebounceTime[r][c] = millis(); //logs stopwatch time to reset debounce timer

        if (reading == LOW) {
          Joystick.setButton(buttonNumber, 1); //Tells PC button is pressed
        } else {
          Joystick.setButton(buttonNumber, 0); //tells PC button is released
        }
      }
    }
    digitalWrite(rowPins[r], HIGH); //Close the gate before moving to the next one
  }

  // Toggle switch
  // Becuase INPUT_PULLUP, ! is used to make sure game takes the right input
  Joystick.setButton(9, !digitalRead(sw1_up));
  Joystick.setButton(10, !digitalRead(sw1_down));
  Joystick.setButton(11, !digitalRead(sw2_up));
  Joystick.setButton(12, !digitalRead(sw2_down));

  Joystick.sendState();
  delay(2);
}
