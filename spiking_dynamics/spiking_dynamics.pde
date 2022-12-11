/**
Sketch for spiking dynamics
**/
enum NeuronType {eRegular_spiking, eIntrinsically_bursting, 
                 eChattering, eFast_spiking, eLow_threshold, eResonator}
int framerate=90;
int substeps = 2;
int numunits = 5;
int tsteps = framerate/3;
float maxspkval = 64;

// single units
SpikingUnit[] units = new SpikingUnit[numunits];
float[][] exc_matrix = {{0, 1, 1, 1, 1}, 
                        {0, 0, 1, 0, 0}, 
                        {0, 1, 0, 1, 0}, 
                        {0, 0, 1, 0, 1}, 
                        {0, 1, 0, 1, 0}
                        };
//float[] sensor_inp =   {100, 100, 0, 
//                        0, 0, 0, 
//                        0, 100, 100
//                        };
                        
float[] base_act = new float[numunits];                          


Buffer[] data = new Buffer[numunits];
Buffer spikerate = new Buffer(tsteps);
Buffer delay = new Buffer(50);

// populations
int popsize = 9;
SpikingPopulation sensorpop;

void setup(){
  size(900, 900);
  noStroke();
  fill(255);
  rectMode(CENTER);
  NeuronType[] ntypes = {NeuronType.eRegular_spiking, 
                         NeuronType.eRegular_spiking, 
                         NeuronType.eFast_spiking,
                       NeuronType.eRegular_spiking,
                     NeuronType.eRegular_spiking};
  frameRate(framerate);
  for(int i=0; i<numunits; i++){
    //units[i] = new SpikingUnit("S"+(i+1), NeuronType.eRegular_spiking, substeps);
    units[i] = new SpikingUnit("S"+(i+1), ntypes[i], substeps);
    data[i] = new Buffer(tsteps);
  }
  
  sensorpop = new SpikingPopulation("Sensor", popsize, NeuronType.eRegular_spiking, tsteps);
   //<>// //<>//
}

void draw(){
  draw_spike_pop();
}

void draw_spike_pop(){
  background(51);
  float[][] sensor_int_top = {{0, 1, 0, 1, 0, 0, 0, 0, 0}, 
                              {1, 0, 1, 0, 1, 0, 0, 0, 0}, 
                              {0, 1, 0, 0, 0, 1, 0, 0, 0}, 
                              {1, 0, 0, 0, 1, 0, 1, 0, 0}, 
                              {0, 1, 0, 1, 0, 1, 0, 1, 0}, 
                              {0, 0, 1, 0, 1, 0, 0, 0, 1}, 
                              {0, 0, 0, 1, 0, 0, 0, 1, 0}, 
                              {0, 0, 0, 0, 1, 0, 1, 0, 1}, 
                              {0, 0, 0, 0, 0, 1, 0, 1, 0}
                              };
  sensorpop.setInternalTopology(sensor_int_top);    
  int stimval = 50;
  float[] sensor_inp =   {stimval, stimval, 0, 
                        0, 0, 0, 
                        0, stimval, stimval
                        };
  sensorpop.setDirect(sensor_inp);
  sensorpop.tick();
  
  
  // viz
  pushMatrix();
  translate(74, 298);
  drawSpikeStrip(sensorpop.getBuffers(), maxspkval);
  popMatrix();
  int rows = 3; int cols = 3;
  float [][] decod_act = new float[rows][cols];
  for(int j=0; j<rows; j++)
    for(int i=0; i<cols; i++){
      float[] spk = sensorpop.getBuffers()[i+rows*j].array();
      
      decod_act[j][i] = 20*countSpikes(spk, maxspkval);
      //println(decod_act[j][i]);
    }
  pushMatrix();
  translate(74, 500);
  drawColGrid(0, 0, 100, decod_act);
  popMatrix();
}

void draw_spikeunit(){
  background(51);
  base_act[0] = 20;
  base_act[1] = 0;
  base_act[2] = 0;
  //circle(148,141, 100);
  //units[1].setDbg(true);
  for(int i=0; i<numunits; i++){
    units[i].setDirect(base_act[i]);
    units[i].tick();
  }
  updateConn(exc_matrix, units); //<>// //<>// //<>//
  
  // update with buffer delay
  delay.append(units[0].getOutput());
  int dl = min(13, delay.array().length-1) ;
  units[1].excite(delay.get(dl));
  
  // draw time series plot
  pushMatrix();
  scale(1, 0.7);
  float[][] plotcrds = {{50, 50},{190, 50},{335, 50},{483, 50},{640, 50}};
  for(int i=0; i<numunits; i++){
    data[i].append(units[i].getVlt());
    pushMatrix();
    translate(plotcrds[i][0], plotcrds[i][1]);
    drawTimeSeries(data[i].array(), 94, 2, -65);
    popMatrix();
  }
  popMatrix();
  // draw topology
  pushMatrix();
  translate(50, 244);
  float[][] topcrds = {{50, 183},{100, 150},{155, 211},{165, 272},{32, 275}};
  drawGraph(topcrds, exc_matrix);
  popMatrix();
  
  // draw spike plot
  pushMatrix();
  translate(74, 298);
  drawSpikeStrip(data, maxspkval);
  popMatrix();
  
  // draw time plot of spikenum
  spikerate.append(countSpikes(data[0].array(), maxspkval));
  pushMatrix();
  translate(260, 353);
  drawTimeSeries(spikerate.array(), 16, 2, 0);
  popMatrix();
  
  // draw phase rotation for a neuron
  pushMatrix();
  translate(52, 40);
  draw_rot_line(units[0].getPhase(), 0, 0);
  popMatrix();
  
}

void updateConn(float[][] matrix, SpikingUnit[] units){

  for(int j=0; j<matrix.length; ++j){
    for(int i=0; i<matrix[0].length; ++i){
      if(matrix[j][i] > 0)
        units[i].excite(units[j].getOutput());//, units[j].getPhase());
      else if(matrix[j][i] < 0)
        units[i].inhibit(units[j].getOutput());//, units[j].getPhase());
    }
  }
  
}
