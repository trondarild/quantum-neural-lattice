void printArray(String s, float [] a){
  print(s+": ");
  for (int i=0; i<a.length; i++)
    print(Float.toString(a[i]) + "; "); 
  println();
}

void draw_rot_line(float angle, float trans_x, float trans_y){
  pushMatrix();
  translate(trans_x, trans_y);
  stroke(165);
  circle(0,0,line_len*2);
  strokeWeight(str_weight);
  rotate(angle);
  line(0,0, line_len, 0);
  popMatrix();
}

void drawArc(float angle, float trans_x, float trans_y, float line_len, float str_weight){
  pushMatrix();
  pushStyle();
  translate(trans_x, trans_y);
  stroke(165);
  fill(70);
  circle(0,0,line_len*2);
  strokeWeight(str_weight);
  fill(150);
  arc(0,0, line_len*2, line_len*2, 0, angle);
  //rotate(angle);
  //line(0,0, line_len, 0);
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
  String legend) {
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

void drawGraph(QuantumNeuralUnit[] units, float[][] adjmatrix){
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
    circle(units[j].getVtx()[0], units[j].getVtx()[1], outer);
    fill(incol);
    circle(units[j].getVtx()[0], units[j].getVtx()[1], inner);
    popStyle();
    // text
    pushStyle();
    fill(txtcol);
    text("U" + (j+1), units[j].getVtx()[0], units[j].getVtx()[1] + outer+5);
    popStyle();
    for(int i=0; i<adjmatrix[0].length; i++){
        if(adjmatrix[j][i] != 0){
          float[] from = units[j].getVtx();
          float[] to = units[i].getVtx();
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

float[][][] computePhaseDiffMatrix(QuantumNeuralUnit[] aunits){
  int res = aunits[0].getPhase().length;
  int sz = aunits.length;
  float[][][] retval = new float[sz][sz][res];
  for(int j=0; j<sz; j++){
    for(int i=0; i<sz; i++){
      for(int k=0; k<res; k++){
        if(j!=i){
          float a = abs(aunits[j].getPhase()[k]-aunits[i].getPhase()[k]);
          float b = TWO_PI-a;
          retval[j][i][k] = min(a, b);
        }
      }
    }
  }
  return retval;
}

void drawPhaseDiffLattice(float[][][] apd){
  pushStyle();
  int res = apd[0][0].length;
  int sz = apd.length;
  float margin = 55;
  float lnlen = 21;
  float lnwt = 3;
  float tr_y=0;
  for(int j=0; j<sz; j++){
    float tr_x = 0;
    for(int i=0; i<sz; i++){      
      for(int k=0; k<res; k++){
        drawArc(apd[j][i][k], tr_x, tr_y, lnlen, lnwt);
        tr_x+=margin;
      }
      tr_x+=margin;
      text("U"+(i+1), tr_x + -167, sz*margin+-205);
    }
    tr_y+=margin;
    text("U"+(j+1), -54, tr_y-57);
    
  }
  popStyle();
}

void old_draw(){
  background(51);
  // jitter
  float delta = delta_init + random(0, 0.1);
  // rotating line
  angle_a -= delta;
  // float c = sin(angle);
  // draw_rot_line(angle, width/2+line_len/2, height/2); 
  float y = height/6; 
  float x_lattice = 6;
  float x_fudge = 51;
  for(int i=0; i<x_lattice; i++){
    float x = width * i/x_lattice  + line_len/2+ x_fudge; 
    draw_q_phase_line(angle_a, i+1, x, y);
  }


  angle_b -= delta*4/3;
  y = height/2;
  for(int i=0; i<x_lattice; i++){
    float x = width * i/x_lattice  + line_len/2 + x_fudge; 
    draw_q_phase_line(angle_b, i+1, x, y);
  }

}
