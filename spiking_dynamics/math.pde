float[][] zeros(int rows, int cols){
  float[][] ret = new float[rows][cols];
  return ret;
}

float[][] id(int sz){
  float [][] ret = zeros(sz, sz);
  for (int j=0; j<=ret.length; j++)
    for (int i=0; i<=ret[0].length; i++)
      if (j==i) ret[j][i] = 1;
  return ret;
}

float[][] ones(int rows, int cols){
  float [][] ret = zeros(rows, cols);
  for (int j=0; j<=ret.length; j++)
    for (int i=0; i<=ret[0].length; i++)
      ret[j][i] = 1;
  return ret;
}
