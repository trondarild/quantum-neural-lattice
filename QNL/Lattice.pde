
import java.util.Arrays;
/**
Unit has size = 1
*/
final float mindelta = 0.001;
class QuantumNeuralUnit{
 // variables
 String name;
 float [] output; // contains activity at each 
 float [] phase; // contains phase angle
 float [] phase_modulation; // modulation due to excitation, inhibition
 float [] phasediff;
 float [] excitation; 
 float [] inhibition; 
 float [] freq_delta;
 float [] base_excitation;
 float [] x;
 int resolution;
 float epsilon;
 float dt;
 float [] vertex;
 // constructor
 QuantumNeuralUnit(  String aname,
                     int aresolution,
                     float amaxfreq,
                     float aepsilon,
                     float adt){
                       
   name = aname;                      
   epsilon = aepsilon;
   resolution = aresolution;
   dt = adt;
   
   output = new float[resolution];
   phase = new float[resolution];
   phase_modulation = new float[resolution];
   phasediff = new float[resolution];
   excitation = new float[resolution];
   inhibition = new float[resolution];
   freq_delta = new float[resolution];
   base_excitation = new float[resolution];
   
   x = new float[resolution];
   float incr = amaxfreq/resolution;
   for(int i=0; i< resolution; i++){
     freq_delta[i] = incr*(i+1);
     // set phase to random
     phase[i] = random(0, TWO_PI);
   }
   vertex = new float[2];
   vertex[0] = random(0, 10);
   vertex[1] = random(0, 10);
 }
 
 
 // accessors
 void setBaseActivity(float[] a){
   for(int i=0; i<resolution; i++)
     base_excitation[i] = a[i];
 }
 
 void setVtx(float x, float y){
    vertex[0] = x;
    vertex[1] = y;
 }
 //void setTickResolution (float a){
 //  tick_resolution = a;
 //}
 
 float[] getOutput(){
   return output;
 }
 float[] getPhase(){
   return phase;
 }
 
 float[] getPhaseDiff(){
   return phasediff;
 }
 
 float[] getVtx(){  //<>// //<>//
   return vertex;
 }  //<>// //<>//
 
 /// methods
 void excite(float[] aExc, float[] aExcPhase){
   // using separate excite allows multiple inputs 
   for (int i=0; i<resolution; i++){
     float pd = calcPhaseDiff(aExcPhase[i],phase[i]);
     phasediff[i] += pd;
     // print(name); println(": phasediff: " + (pd));
     excitation[i] += aExc[i]*abs(cos(pd)); ///tick_resolution;
     phase_modulation[i] += aExc[i]*pd; ///tick_resolution;
   } 
   
 }
 
 void excite_b(float[] aExc, float[] aExcPhase){
   // using separate excite allows multiple inputs
   // every input can affect all energy bands dept on phase
   for (int i=0; i<resolution; i++){
     for (int j=0; j<resolution; j++){
       float pd = calcPhaseDiff(aExcPhase[j], phase[i]);
       phasediff[i] += pd;
       // print(name); println(": phasediff: " + (pd));
       excitation[i] += aExc[j]*abs(cos(pd)); ///tick_resolution;
       phase_modulation[i] += aExc[j]*pd; ///tick_resolution;
     }
   } 
   
 }
 
 void inhibit(float[] aInh, float[] aInhPhase){
   for (int i=0; i<resolution; i++){
     float pd = calcPhaseDiff(aInhPhase[i]+PI, phase[i]); // keep lead, lag for phase mod?
     phasediff[i] += pd;
     // print(name); println(": phasediff: " + (pd));
     inhibition[i] += aInh[i]*abs(cos(abs(pd))); ///tick_resolution;
     phase_modulation[i] -= aInh[i]*pd; /// push away instead of draw close?
   }
 }

 void inhibit_b(float[] aInh, float[] aInhPhase){
   for (int i=0; i<resolution; i++){
     for (int j=0; j<resolution; j++){
       float pd = calcPhaseDiff(aInhPhase[j], phase[i]); // keep lead, lag for phase mod
       phasediff[i] += pd;
       // print(name); println(": phasediff: " + (pd));
       inhibition[i] += aInh[j]*abs(cos(abs(pd))); ///tick_resolution;
       phase_modulation[i] = max(0, phase_modulation[i]-aInh[j]*pd); /// push away instead of draw close?
     }
   }
 }

 void tick(){
   // update output
   excite(base_excitation, phase);
   for (int i=0; i<resolution; i++){
     float a = excitation[i]-inhibition[i];
     x[i] += (epsilon * (a - x[i])); //* dt
    
     //if(x[i] > 1){  // excitation to next energy level
     //  if(i < resolution-1) {
     //    excitation[i+1] += excitation[i]-1; // only transfer energy above threshold
     //    excitation[i] = 0; // annihilate energy below threshold
     //    //x[i+1] += x[i] -1; // doesnt work with updating x
     //    //x[i] = 0;
     //    output[i] = 0;
     //  } else if(i==resolution-1)
     //    output[i] = 1;
     //} 
     //else {
     //  output[i] = activate(x[i]);
     //}
   }
   float[] delta = new float[resolution]; 
   // update for inhibition, from top, pushing down
   for(int i=resolution-1; i>=0; i--){
     //if(i==resolution-1)
     if(i>=1)
       delta[i] = min(max_upw_potential(i-1, x)+x[i], 1);
      
     if(x[i] < 0){
       if(i > 0)
         x[i-1] += x[i]; // fails at 0
       else
         x[i] = 0;
       delta[i] = 0;
     } else
       delta[i] = x[i];
     
   }
   
   // update phase by rotation
   for (int i=0; i<resolution; i++){
     output[i] = activate(delta[i]);
     //phase[i] += output[i]*freq_delta[i]/tick_resolution;
     float rotation =  output[i]>mindelta? freq_delta[i] : 0;
     phase[i] += (rotation + phase_modulation[i])*dt;
     if(phase[i] > TWO_PI || phase[i] < -TWO_PI)
       phase[i] = 0;  
     
   }
   
   Arrays.fill(excitation, 0);
   Arrays.fill(inhibition, 0);
   Arrays.fill(phasediff, 0);
   Arrays.fill(phase_modulation, 0);
   
 }
  //<>// //<>//

 
 float activate(float a){
    return relu(a);     
}

float scaledSigmoid(float a){
    if(a < 0)
      return 0;
    else
      return atan(a)/tan(1);       
}

float relu(float x){
    if(x < 0)
        return 0;
    else
        return x;
}
 void debug(){
   println(name);
   printArray("output", output); // contains activity at each 
   printArray("phase", phase); // contains phase angle
   printArray("excitation", excitation); 
   printArray("freq_delta", freq_delta);
   printArray("phasediff", phasediff);
   printArray("x", x);
   println();
 }
 
 float max_upw_potential(int i, float[] ax){
   float retval;
   if(i==0)
     return ax[0];
   else {
     retval = max(0, ax[i] + max(0, max_upw_potential(i-1, ax)-1));
     return retval;
   }
 }
 
 float calcPhaseDiff(float a, float b){
    float retval = abs(a-b);
    if (retval > PI)
        retval = TWO_PI-a + b;
    return retval;
 }
 
}
