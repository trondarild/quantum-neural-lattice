//
//
import java.util.Arrays;
float topology[][];
int dim = 3;
void setup(){
  size(400, 400);
  frameRate(10);
  topology = zeros(dim*dim, dim*dim);
}

void draw(){
  background(51);
  fill(200);
  //circle(width/2, height/2, 100);
  
  pushMatrix();
  translate(30,30);
  topology = makeTopology(dim, 1);
  drawTopologyGrid(0, 0, 19, topology);
  popMatrix();
  
  //int [][] ixm = makeIxMatrix(3, 3, 1);
  //printMatrix("ixm", ixm);
}



/*
* dim: size of pixel array (must be dim*dim)
* type: nearest neigh=1,  
*/
float[][] makeTopology(int dim, int type){
 float[][] retval = new float[dim*dim][dim*dim];
  // types
 // 1 nearest neighbor
 // 2 random
 /*
  [M, N] = size(T);
  [X, Y] = meshgrid(max(1,m-5):min(M,m+5), max(1,n-5):min(N,n+5));
  I = sub2ind(size(T), X(:), Y(:));
 */
 switch (type){
   case 1: // nearest neighbor
     // make a source matrix filled with indeces and a border equal to 
     // kernel size
     int[][] kernel ={{-1,-1}, {-1, 0}, {-1, 1},
                       {0,-1}, {0, 1},
                     {1,-1}, {1,0}, {1,1}};
     int border = 1; 
     int[][] ixm = makeIxMatrix(dim, dim, border);
     
     // every kernel movement adds a row to output topology
     int ctr = 0;
     for(int j=border; j<ixm.length-border; j++)
     {
       for(int i=border; i<ixm.length-border; i++)
       {
         for(int k=0; k<kernel.length; k++)
          {
            int ix = ixm[j+kernel[k][0]] [i+kernel[k][1]]; //<>//
            // println("j= "+j+", i= " +i+ ", k= "+k+", ix= "+ix);
            if(ix>=0) retval[ctr][ix]=1; 
          } //<>//
          ctr++;
       }
     }
       
     
     break;
   default:
   break;
 }
 return retval;
}

int[][] makeIxMatrix(int x, int y, int border){
  int [][] retval = new int[y+2*border][x+2*border];
  int ctr=0;
  for (int[] row: retval)
    Arrays.fill(row, -1);
  //Arrays.fill(retval, -1);
  for(int j=border; j<retval.length-border; j++)
  {
    for(int i=border; i<retval[0].length-border; i++)
    {
      retval[j][i] = ctr;
      ctr++;
    }
  }
  return retval;
  
}
