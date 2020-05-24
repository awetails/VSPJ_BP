class CGrid{
  //CGrid consists of dim_x X dim_y tiles. There is no "empty Tile" the loves number on tile is zero
    int _dim_x = 4;
    int _dim_y = 4;

    CTile[][] grid = new CTile[_dim_x][_dim_y];

    CGrid(){
        for (int i = 0; i < _dim_x; ++i){
            for (int j = 0; j < _dim_y; ++j){
                grid[i][j] = new CTile();
            }
        }
    }

    CTile getTile(int x, int y){
        return grid[x][y];
    }

    void setTile(CTile tile, int x, int y){
         grid[x][y] = tile;
    }

    int getXdim(){
        return _dim_x;
    }

    int getYdim(){
        return _dim_y;
    }
    
    int getLinear(int i){
      int x = int(i/_dim_y);
      int y = i % _dim_x;
      return getTile(x,y).getValue();
    }
    
    ArrayList<CTile> get_highest(){
      ArrayList<CTile> highest = new ArrayList<CTile>();
      highest.add(getTile(0,0));
      for (int i = 0; i < _dim_x; ++i){
        for (int j = 0; j < _dim_y; ++j){
          if (i == 0 && j ==0){
            continue;
          }
          if (highest.get(0).getValue() > getTile(i,j).getValue()){
            continue;
          }
          if (highest.get(0).getValue() == getTile(i,j).getValue()){
            highest.add(getTile(i,j));
          }
          if (highest.get(0).getValue() < getTile(i,j).getValue()){
            for (int k = highest.size() - 1; k >= 0; --k){
              highest.remove(k);
            }
            highest.add(getTile(i,j));
          }
        }
      }
      return highest;
    }

    void draw(int dim_x, int dim_y){
        int x_step = dim_x / _dim_x;
        int y_step = dim_y / _dim_y;

        for (int x = 0; x < _dim_x; ++x){
            for (int y = 0; y < _dim_y; ++y){
                grid[x][y].draw(x*x_step, y*y_step, x_step, y_step);
            }
        }
    }
}
