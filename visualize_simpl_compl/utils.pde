void draw_rot_line(float angle, float trans_x, float trans_y, float line_len, float str_weight){
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

void drawPhaseDiffLattice(float[][][] apd){
  int res = apd[0][0].length;
  int sz = apd.length;
  float margin = 60;
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
    }
    tr_y+=margin;
  }
}

float[][][] computePhaseDiffMatrix(float[][] aunits){
  int res = aunits[0].length;
  int sz = aunits.length;
  float[][][] retval = new float[sz][sz][res];
  for(int j=0; j<sz; j++){
    for(int i=0; i<sz; i++){
      for(int k=0; k<res; k++){
        if(j!=i){
          float a = abs(aunits[j][k]-aunits[i][k]);
          float b = TWO_PI-a;
          retval[j][i][k] = min(a, b);
        }
      }
    }
  }
  return retval;
}

void printArray(String s, float [] a){
  print(s+": ");
  for (int i=0; i<a.length; i++)
    print(Float.toString(a[i]) + "; "); 
  println();
}

void printArray(String s, float [][][] a){
  println(s+": ");
  for (int j=0; j<a.length; j++){
    for (int i=0; i<a[0].length; i++){
      print("(");
      for (int k=0; k<a[0][0].length; k++)
        print(Float.toString(a[j][i][k]) + "; ");
      print(") ");
    }
    println();
  }
}

void drawSimplicalComplexes(float[][][] pds, float [][][] coords){
  // identify triangles
  int res = 1; //aunits[0].length;
  int sz = pds.length;
  float mindiff = 1.0;
  // float[][][] retval = new float[sz][sz][res];
  for(int j=0; j<sz; j++){
    for(int i=0; i<sz; i++){
      for(int k=0; k<res; k++){
        if(j!=i && pds[j][i][k] < mindiff){
          
        }
      }
    }
  }
  
}
