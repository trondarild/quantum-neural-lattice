// 

import java.util.Arrays;


int resolution = 3;
float epsilon = 1.0;
float [] excitation = new float[resolution];
float [] act = new float[resolution];
float [] output = new float[resolution];
float tick_resolution = 1;
// Declare Header Font
PFont h1;

//Declare Label Font
PFont l1;

void setup(){
  size(400, 600);
  noStroke();
  fill(255);
  rectMode(CENTER);
  frameRate(1);
  h1 = createFont("Monospaced", 12);
  l1 = createFont("Monospaced", 12);
}

void draw(){
  background(51);
  excitation[0] = 0.1;
  excitation[1] = 1.2;
  for (int i=0; i<resolution; i++){
     // float a = excitation[i];
     act[i] += epsilon * (excitation[i] - act[i])/tick_resolution;
     // println(" x: " + x[i]);
     // excitation to next energy level
     if(act[i] > 1){ 
       if(i < resolution-1) {
         output[i] = 0;
         //excitation[i+1] += excitation[i]-1; // only transfer energy above threshold
         //excitation[i] = 0; // transfer annihilates energy below threshold
         act[i+1] += act[i] -1;
         act[i] = 0;
       } else if(i==resolution-1)
         output[i] = 1;
      else {
       output[i] = act[i] < 0 ? 0 : (act[i]);
      }
    }
  }
  printArray("act", act);
  printArray("output", output);
  
  float line_len = 10;
  float x_fudge = 50;
  float y = line_len+100;
  float x=x_fudge;
  float yscl = 60.9;
  float xscl = 134.0;
  color clr = color(246, 105, 122, 255);
  float ymax = 1.1;
  
  barchart_array(act,
  y, 
  x, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax);
  
  x += 163; 
  barchart_array(output,
  y, 
  x, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax);
  
  Arrays.fill(excitation, 0);
  Arrays.fill(act, 0);
}
