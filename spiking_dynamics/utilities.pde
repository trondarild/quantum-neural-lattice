void printArray(String s, float [] a){
  print(s+": ");
  for (int i=0; i<a.length; i++)
    print(Float.toString(a[i]) + "; "); 
  println();
}

void draw_rot_line(float angle, float trans_x, float trans_y){
  float lnlen = 10;
  float wt = 2;
  draw_rot_line(angle, trans_x, trans_y, lnlen, wt);
}


void draw_rot_line(float angle, float trans_x, float trans_y, float line_len, float str_weight){
  pushMatrix();
  pushStyle();
  translate(trans_x, trans_y);
  stroke(165);
  circle(0,0,line_len*2);
  strokeWeight(str_weight);
  rotate(angle);
  line(0,0, line_len, 0);
  popStyle();
  popMatrix();
}

void draw_q_phase_line(float angle, int quant, float trans_x, float trans_y){
  float q_angle = 2*PI/(float)quant;
  float flr =  ceil(angle/q_angle); // use ceil to round negs towards zero
  float rotangle = q_angle * flr;
  // print(angle);
  // print("; ");
  // println(rotangle);
  draw_rot_line(rotangle, trans_x, trans_y);
}

void barchart_array(float[] data,
  float yf1, 
  float xf1, 
  float yscale, 
  float xscale, 
  color clr, 
  int labelplacement,
  float aymax,
  String legend,
  PFont h1,
  PFont l1) {
  //Declare a float variabe for the max y axis value.
   float ymax=aymax;
   
   //Declare a float variable for the minimum y axis value.
   float ymin = 0;
   
   //Set the stroke color to a medium gray for the axis lines.
   stroke(175);
   
   //draw the axis lines.
   line(xf1-3,yf1+2,xf1+xscale,yf1+2);  
   line(xf1-3,yf1+2,xf1-3,yf1-yscale); 
     
   //turn off strokes for the bar charts 
   noStroke(); 
    
   //loop the chart drawing once.
   for (int c1 = 0; c1 < 1; c1++){  
   
     //Set the start x point value.
     float xfstart = xf1;  
     //Count the number of rows in the file.
     //for (int i = 0; i < lines.length; i++) {
       
       //For each line split values separated by columns into pieces.
       //String[] pieces = split(lines[i], ',');
       
       //Set the max Y axis value to be 10 greater than the max value in the pieces array.
       // ymax = 1.5* max(data);
       
       //Count the number of pieces in the array.
       float xcount = data.length;
       
       //Draw the minimum and maximum Y Axis labels. 
       textFont(h1);
       fill (100);
       textAlign(RIGHT, CENTER);
       text(int(ymax), xf1-8, yf1-yscale);
       text(int(ymin), xf1-8, yf1);
       text(legend, xf1+87, yf1+18);
       
       //Draw each column in the data series.
       for (int i2 = 0; i2 < xcount; i2++) {
         
         //Get the column value and set it has the height.
         float yheight = data[i2];
         
         //Declare the variables to hold column height as scaled to the y axis.     
         float ypct;
         float ysclhght;
         
         //calculate the scale of given the height of the chart.
         ypct = yheight / ymax;
         
         //Calculate the scale height of the column given the height of the chart.
         ysclhght = yscale * ypct;
         
         //If the column height exceeds the chart height than truncate it to the max value possible.
         if(ysclhght > yscale){
           ysclhght = yscale;
         }
         
         //Determine the width of the column placeholders on the X axis.
         float xcolumns = xscale / xcount;
         
         //Set the width of the columns to 5 pixels less than the column placeholders.
         float xwidth = xcolumns - 5;
         
         //Set the fill color of the columns.
         fill (clr);
         
         //Draw the columns to scale.
         quad(xf1, yf1, xf1, yf1-ysclhght, xf1 + xwidth, yf1-ysclhght, xf1 + xwidth, yf1);
         
         //Draw the labels.
         textFont(l1);
         textAlign(CENTER, CENTER);
         fill (100);
         
         //Decide where the labels will be placed.
         if (labelplacement < 1) {
           //Above the columns.
           text(nf(data[i2], 0, 2), xf1 + (xwidth / 2), yf1 - (ysclhght + 8));
         } else {
           //Below the columns.
           text(data[i2], xf1 + (xwidth / 2), yf1 + 8);
         }
         //increment the x point at which to draw a column.
         xf1 = xf1 + xcolumns;
       //}
    }
  }
}

/**
*/
void drawGraph(float[][] units, float[][] adjmatrix){
  pushStyle();
  float inner = 10.9;
  float outer= 40.3;
  color incol = color(0,0,0,151);
  color outcol = color(222, 147);
  color txtcol = color(200);
  color excol = color(217,122,122,255);
  color inhcol= color(122,122,217,255);
  color linecol;
  for(int j=0; j<adjmatrix.length; j++){
    pushStyle();
    fill(outcol);
    circle(units[j][0], units[j][1], outer);
    fill(incol);
    circle(units[j][0], units[j][1], inner);
    popStyle();
    // text
    pushStyle();
    fill(txtcol);
    text("U" + (j+1), units[j][0], units[j][1] + outer+5);
    popStyle();
    for(int i=0; i<adjmatrix[0].length; i++){
        if(adjmatrix[j][i] != 0){
          float[] from = units[j];
          float[] to = units[i];
          pushStyle();
          strokeWeight(4);
          linecol = excol;
          if(adjmatrix[j][i] < 0)
            linecol = inhcol;
          stroke(linecol);
          arrow(from[0], from[1], to[0], to[1]);
          popStyle();
        }
    }
  }
  popStyle();
}

void arrow(float x1, float y1, float x2, float y2) {
  float pt = 7;
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -pt, -pt);
  line(0, 0, pt, -pt);
  popMatrix();
} 

void drawTopologyGrid(float x1, float y1, float dim, float[][] top){
  color exccol = color(217,122,122,255);
  color inhcol= color(122,122,217,255);
  
  float y=y1;
  float margin = 10;
  for(int j=0; j<top.length; j++){
    float x=x1;
    for(int i=0; i<top[0].length; i++){
      pushStyle();
      if(top[j][i] > 0) fill(exccol);
      else if(top[j][i] < 0) fill(inhcol);
      else fill(100);
      square(x, y, dim);
      popStyle();
      x+= dim+margin;
    }
    y+= dim+margin;
  }
}

void drawColGrid(float x1, float y1, float dim, float[][] top){
  color exccol = color(217,122,122,255);
  color inhcol= color(122,122,217,255);
  
  float y=y1;
  float margin = 10;
  for(int j=0; j<top.length; j++){
    float x=x1;
    for(int i=0; i<top[0].length; i++){
      pushStyle();
      if(top[j][i] > 0) fill(top[j][i]);
      else if(top[j][i] < 0) fill(inhcol);
      else fill(0);
      square(x, y, dim);
      popStyle();
      x+= dim+margin;
    }
    y+= dim+margin;
  }
}

/** Draw a time-series plot
*/
void drawTimeSeries(float[] series, float maxy, float x_margin, float thresh){
 float y_length=100;
 float x_length=100;
// float x_margin = 20;
 //float ptsz = 10;
 pushStyle();
 stroke(200);
 strokeWeight(2);
 //draw y
 line(0,0,0,2*y_length);
 line(0,y_length, x_length, y_length);
 pushStyle();
 stroke(200, 100, 0);
 float y_thr = y_length*(1 - thresh/maxy);
 line(0,  y_thr, x_length, y_thr); 
 popStyle();
 // draw data
 float x = x_margin;
 pushStyle();
 //fill(150);
 noFill();
 strokeWeight(1);
 beginShape();
 for(int i=0; i<series.length; i++){
   float y = y_length*(1 - series[i]/maxy);
   //circle(x, y,  ptsz);
   vertex(x, y);
   x+=x_margin;
 }
 endShape();
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
  
  float head(){
    return data.get(0);
  }
  
  float get(int ix){
    return data.get(ix);
  }
  
  void append(float val){
    data.append(val);
    data.remove(0);
  }
}

void drawSpikeStrip(Buffer[] aspikes, float threshold){
  pushStyle();
  color ptcolor = color(228, 106, 218);
  float x=0; float y=0;
  float x_i =4; float y_i=10;  
  float margin = 1;
  fill(ptcolor);
  noStroke();
  for(int j=0; j<aspikes.length; j++){
    x=0;
    text("U"+(j+1), x-25, y+5);
    for(int i=0; i<aspikes[0].array().length; i++){
      // draw the strip
    if(aspikes[j].array()[i] > threshold){
      rect(x, y, x_i, y_i);}
    x+= x_i + margin;
    }
   y+= y_i;
  }
  popStyle();
}

int countSpikes(float[] data, float threshold){
  int retval = 0;
  for(int i=0; i< data.length; i++)
    if(data[i] >= threshold) retval++;
  return retval;
}
