int framerate=10;
float t=0;
int lstlen = 5;
//FloatList data = new FloatList(lstlen);
Buffer data = new Buffer(lstlen);

void setup(){
  size(300, 300);
  noStroke();
  fill(255);
  rectMode(CENTER);
  frameRate(framerate);
  //for(int i=0;i<lstlen;i++)
  //  data.append(0);
}

void draw(){
  background(51);
  //println(data.toString());
  //circle(148,141, 100);
  //float[] data = {1,2,3};
  data.append(cos(t));
  //data.remove(0);
  float maxy = 5;
  pushMatrix();
  translate(100, 100);
  drawTimeSeries(data.array(), maxy);
  popMatrix();
  t+=0.5;
  //println(data.toString());
}

void drawTimeSeries(float[] series, float maxy){
 float y_length=100;
 float x_length=100;
 float x_margin = 20;
 float ptsz = 10;
 pushStyle();
 stroke(200);
 strokeWeight(2);
 //draw y
 line(0,0,0,y_length);
 line(0,y_length, x_length, y_length);
 // draw data
 float x = x_margin;
 pushStyle();
 fill(150);
 strokeWeight(0);
 for(int i=0; i<series.length; i++){
   float y = y_length*(1 - series[i]/maxy);
   circle(x, y,  ptsz); 
   x+=x_margin;
 }
 popStyle();
 popStyle();
}

class Buffer{
  FloatList data; 
  Buffer(int sz){
    data = new FloatList(sz);
    for(int i=0; i<sz; i++)
      data.append(0);
  }
  
  float[] array(){
    return data.array();
  }
  
  void append(float val){
    data.append(val);
    data.remove(0);
  }
}
