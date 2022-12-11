/*
Spiking population with connection topology
*/

class SpikingPopulation{
 
  SpikingUnit[] units;
  Buffer[] data;
  float [] output;
  float [][] internal_synapse;
  // constructor
  SpikingPopulation(String name, int sz, NeuronType ntype, int bufsize){
    units = new SpikingUnit[sz];
    output = new float[sz];
    data = new Buffer[sz];
    for(int i=0; i<sz; i++){
      units[i] = new SpikingUnit(name+"_"+(i+1), ntype, 2);
      data[i] = new Buffer(bufsize);
    }
    // default internal synapse is no conn
    internal_synapse = zeros(sz, sz);
  }
  
  // accessors
  float[] getOutput(){
    for(int i=0; i<units.length; i++)
      output[i] = units[i].getOutput();
    return output;
  }
  
  Buffer[] getBuffers(){
    return data;  
  }
  
  void setInternalTopology(float[][] top){
    internal_synapse = top;  
  }
    
  
  // methods
  void tick(){
    for(int i=0; i<units.length; i++){
      units[i].tick();
      data[i].append(units[i].getOutput());
    }
    updateConn(internal_synapse, units);
    
  }
  
  void setDirect(float[] val){
    for(int i=0; i<units.length; i++)
      units[i].setDirect(val[i]);
  }
  
  void excite(float[] val, float[][] synapse){
    // will throw array out of bounds if not matching
    for(int j=0; j<synapse.length; ++j){
      for(int i=0; i<synapse[0].length; ++i){
          if(synapse[j][i] > 0)
            units[i].excite(synapse[j][i] * val[j]);
      }
    }
    
  }
  
  void inhibit(float[] val, float[][] synapse){
    // will throw array out of bounds if not matching
    for(int j=0; j<synapse.length; ++j){
      for(int i=0; i<synapse[0].length; ++i){
          if(synapse[j][i] > 0)
            units[i].inhibit(synapse[j][i] * val[j]);
      }
    }
  }
  
  // privates
  private void updateConn(float[][] matrix, SpikingUnit[] units){

    for(int j=0; j<matrix.length; ++j){
      for(int i=0; i<matrix[0].length; ++i){
        if(matrix[j][i] > 0)
          units[i].excite(units[j].getOutput());//, units[j].getPhase());
        else if(matrix[j][i] < 0)
          units[i].inhibit(units[j].getOutput());//, units[j].getPhase());
      }
    }
  }
}
