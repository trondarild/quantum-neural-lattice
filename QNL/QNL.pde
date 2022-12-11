

/*
 * Sketch for testing out phase locking etc for QuantumNeuralLattice 
 */
 
import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 

MidiBus myBus;
int midiDevice  = 0;

PFont h1; // Declare Header Font
PFont l1; //Declare Label Font

float angle_a;
float angle_b;
float delta_init = 0.04;
float line_len;
float str_weight = 5;
int resolution = 3;
float maxfreq = 6;
float epsilon = 0.5;
//float tick_resolution = 1.0;
float dt = 0.1; // time delta for simulation
int numunits = 3;
QuantumNeuralUnit unit_1, unit_2, unit_3; 
QuantumNeuralUnit[] units = new QuantumNeuralUnit[numunits];

float[] tstexc = new float[resolution];
float[] tstphase = new float[resolution];
float[] base_1 = new float[resolution];
float[] base_3 = new float[resolution];

// excitation connections:
                         //1 2 3  
float[][] exc_matrix = {  {0,1,0},   // 1
                          {0,0,0},   // 2 
                          {-1,0,0} }; // 3
float[][] phase_diff_matrix = new float[numunits][numunits];                         

int framerate = 10;


void setup(){
  size(900, 900);
  noStroke();
  fill(255);
  rectMode(CENTER);
  frameRate(framerate);

  h1 = createFont("Monospaced", 12);
  l1 = createFont("Monospaced", 12);
     
  units[0] = new QuantumNeuralUnit("U1", resolution, maxfreq, epsilon, dt);
  units[1] = new QuantumNeuralUnit("U2", resolution, maxfreq, epsilon, dt);
  units[2] = new QuantumNeuralUnit("U3", resolution, maxfreq, epsilon, dt);
  unit_1 = units[0];
  unit_2 = units[1];
  unit_3 = units[2];
  
  // set up connections
  // exc_matrix[0][1] = 1; // u1->u2
  // exc_matrix[2][1] = 1; // u3->u2
  
  MidiBus.list(); 
  myBus = new MidiBus(this, midiDevice, 1); 
}


void draw(){
  background(51);
  line_len=31;
  float y_start = 50;
  float y_margin = 62;
  
  tstexc[0] = 0.5;
  
  base_1[0] = 0.5;
  //base_1[1] = 0.0;
  //base_1[2] = 0.0;
  
  base_3[0] = 0.6;
  //base_3[1] = 0;
  //base_3[2] = 0;
  //println("baseval 1 : " + base_1[0] +", " + base_1[1]+", " + base_1[2]);
  units[0].setBaseActivity(base_1);
  units[2].setBaseActivity(base_3);
  
  
  unit_1.tick();
  unit_3.tick();
  
  // unit_1.debug();
  updateConn(exc_matrix, units);
  
  float [] phasediff = new float[resolution]; 
  arrayCopy(units[1].getPhaseDiff(), phasediff);
  
  units[1].tick();
  
  //float[] phase_1 = unit_1.getPhase();
  
  float y = y_start; 
  float x_lattice = 6;
  float x_fudge = 38;
  
  for(int i=0; i<resolution; i++){
    float x = width * i/x_lattice  + line_len/2+ x_fudge; 
    draw_rot_line(units[0].getPhase()[i], x, y);
  }
  y += line_len + 10;
  float txt_x = 62;
  text("Phase U1", txt_x, y);
  
  y+=y_margin;
  for(int i=0; i<resolution; i++){
    float x = width * i/x_lattice  + line_len/2+ x_fudge; 
    draw_rot_line(units[1].getPhase()[i], x, y);
  }
  y += line_len+10;
  text("Phase U2", txt_x, y);
  
   y+=y_margin;
  for(int i=0; i<resolution; i++){
    float x = width * i/x_lattice  + line_len/2+ x_fudge; 
    draw_rot_line( units[2].getPhase()[i], x, y);
  }
  y += line_len+10;
  text("Phase U3", txt_x, y);
  
  y+=y_margin;
  // draw barchart for output
  float x=x_fudge;
  float yscl = 47.8;
  float xscl = 134.0;
  color clr = color(246, 105, 122, 255);
  float ymax = 1.1;
  
  barchart_array(unit_1.getOutput(),
  y, 
  x, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax,
  "U1 output");
  
  
  
  x = x_fudge;
  y += line_len+50;
  ymax=1.1;
  barchart_array(unit_2.getOutput(),
  y, 
  x, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax,
  "U2 output");
  
  /*
  float x_pd=200;
  ymax=TWO_PI;
  barchart_array(phasediff,
  y, 
  x_pd, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax,
  "phasediff");
  */
  
  y += line_len+50;
  barchart_array(unit_3.getOutput(),
  y, 
  x, 
  yscl, 
  xscl, 
  clr, 
  0,
  ymax,
  "U3 output");
  
  units[0].setVtx(73,10);
  units[1].setVtx(292,10);
  units[2].setVtx(162,110);
  // draw graph
  pushMatrix();
  translate(width/2, 100);
  scale(1);
  drawGraph(units, exc_matrix);
  popMatrix();
  
  // draw connection matrix
  pushMatrix();
  pushStyle();
  translate(width/2, 381);
  drawTopologyGrid(0, 0, 37, exc_matrix);
  textSize(18); text("Connection matrix", 57, 130);
  popStyle();
  popMatrix();
  
  // draw phase diffs
  float [][][] phasediffs = computePhaseDiffMatrix(units);
  pushMatrix();
  pushStyle();
  translate(width/6, 599);
  drawPhaseDiffLattice(phasediffs);
  textSize(18); text("Phase differences", 287, 164);
  popStyle();
  popMatrix();
  
}

void updateConn(float[][] matrix, QuantumNeuralUnit[] units){

  for(int j=0; j<matrix.length; ++j){
    for(int i=0; i<matrix[0].length; ++i){
      if(matrix[j][i] > 0)
        units[i].excite(units[j].getOutput(), units[j].getPhase());
      else if(matrix[j][i] < 0)
        units[i].inhibit(units[j].getOutput(), units[j].getPhase());
    }
  }
  
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
  int note = (int)(message.getMessage()[1] & 0xFF) ;
  int vel = (int)(message.getMessage()[2] & 0xFF);

   println("Bus " + bus_name + ": Note "+ note + ", vel " + vel);

  
  //float valx = map(vel, 0, 128, 0, width);
  //float valy = map(vel, 0, 128, 0, height);
  //float col = map(vel, 0, 129, 0, 255);
  float baseval = map(vel, 0, 128, 0, 2);
  //println("baseval: " + baseval);
  
  if(note==81)
    base_1[0]=baseval;
  if(note==82)
    base_1[1]=baseval;
  if(note==83)
    base_1[2]=baseval;
  
  if(note==84)
    base_3[0]=baseval;
  if(note==85)
    base_3[1]=baseval;
  if(note==86)
    base_3[2]=baseval;
    
  // modify topology
  if(note==65) // excitation
    exc_matrix[0][0] = baseval;
  if(note==66)
    exc_matrix[0][1] = baseval;
  if(note==67)
    exc_matrix[0][2] = baseval;
  
  if(note==73) // inhibition
    exc_matrix[0][0] = -baseval;
  if(note==74)
    exc_matrix[0][1] = -baseval;
  if(note==75)
    exc_matrix[0][2] = -baseval;
    
  if(note==68) // excitation
    exc_matrix[2][0] = baseval;
  if(note==79)
    exc_matrix[2][1] = baseval;
  if(note==70)
    exc_matrix[2][2] = baseval;
  
  if(note==76) // inhibition
    exc_matrix[2][0] = -baseval;
  if(note==77)
    exc_matrix[2][1] = -baseval;
  if(note==78)
    exc_matrix[2][2] = -baseval;
}
