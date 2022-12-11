void barchart_array(float[] data,
  float yf1, 
  float xf1, 
  float yscale, 
  float xscale, 
  color clr, 
  int labelplacement,
  float aymax) {
  //Declare a float variabe for the max y axis value.
   float ymax=aymax;
   
   //Declare a float variable for the minimum y axis value.
   float ymin = 0;
   
   //Set the stroke color to a medium gray for the axis lines.
   stroke(175);
   
   //draw the axis lines.
   line(xf1-3,yf1+2,xf1+xscale,yf1+2); //<>// //<>//
   line(xf1-3,yf1+2,xf1-3,yf1-yscale); //<>// //<>//
    //<>// //<>//
   //turn off strokes for the bar charts. //<>// //<>// //<>// //<>// //<>//
   noStroke(); //<>// //<>//
    //<>// //<>// //<>// //<>//
   //loop the chart drawing once.
   for (int c1 = 0; c1 < 1; c1++){ //<>// //<>// //<>//
   
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
           //Above the columns. nf(f3, 0, 2)
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

void printArray(String s, float [] a){
  print(s+": ");
  for (int i=0; i<a.length; i++)
    print(Float.toString(a[i]) + "; "); 
  println();
}
