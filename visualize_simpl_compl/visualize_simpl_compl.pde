/**
Visualize simplicial complexes of phase-locked nodes
*/
int numunits = 3;
int resolution = 3;
float[][] units = new float[numunits][resolution];

void setup(){
  size(900, 900);
  noStroke();
  fill(255);
  rectMode(CENTER);
  // fill with randoms
  for(int j=0; j<numunits; j++){
    for(int i=0; i<resolution; i++){
      units[j][i] = random(0, TWO_PI);  
    }
  }
}

void draw(){
  background(51);
  float [][][] phasediff = computePhaseDiffMatrix(units);
  
  //printArray("phasediff: ", phasediff);
  translate(131, 186);
  drawPhaseDiffLattice(phasediff);
  
  
}
