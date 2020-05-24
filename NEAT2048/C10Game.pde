class CGame {
  //CGame wraps a game grid and the current state of the game as well as provides I/O operations
  boolean _visible = false;
  boolean _finished = false;
  
  int _last_status;
  int _last_move;
  
  int _moves = 1;

  CGrid grid = new CGrid();

  static final int CONTINUE     = 0;
  static final int END          = 1;
  static final int ILLEGAL_MOVE = 2;

  static final int PLAY_UP      = 0;
  static final int PLAY_DOWN    = 1;
  static final int PLAY_LEFT    = 2;
  static final int PLAY_RIGHT   = 3;

  boolean create_random() {
    ArrayList<CTile> empty = new ArrayList<CTile>();

    int x_dim = grid.getXdim();
    int y_dim = grid.getYdim();

    //get empty
    for (int x = 0; x < x_dim; ++x) {
      for (int y = 0; y < y_dim; ++y) {
        CTile tile = grid.getTile(x, y);
        if (tile.getValue() == 0) {
          empty.add(tile);
        }
      }
    }

    if (empty.size() < 2) {
      return false;
    }


    empty.get(int(random(empty.size()))).increment();
    empty.get(int(random(empty.size()))).increment();

    return true;
  }
  
  int get_highest(){
    return grid.get_highest().get(0).getValue();
  }

  int play(int move) {
    if (move > 3) return ILLEGAL_MOVE;

    boolean legal = false;

    int x_dim = grid.getXdim();
    int y_dim = grid.getYdim();

    if (move == PLAY_UP) {
      for (int x = 0; x < x_dim; ++x) {
        for (int y = 0; y < y_dim - 1; ++y) {
          if (grid.getTile(x, y).getValue() == 0) {
            for (int dy = y; dy <= y_dim - 1; ++dy) {
              if (grid.getTile(x, dy).getValue() != 0) {
                grid.getTile(x, y).setValue(grid.getTile(x, dy).getValue());
                grid.getTile(x, dy).setValue(0);
                for (int ddy = dy; ddy <= y_dim - 1; ++ddy) {
                  if (grid.getTile(x, ddy).getValue() == grid.getTile(x, y).getValue()) {
                    grid.getTile(x, y).increment();
                    grid.getTile(x, ddy).setValue(0);
                    break;
                  }
                }
                break;
              }
            }
          } else {
            for (int ddy = y + 1; ddy <= x_dim - 1; ++ddy) {
              if (grid.getTile(x, ddy).getValue() == grid.getTile(x, y).getValue()) {
                grid.getTile(x, y).increment();
                grid.getTile(x, ddy).setValue(0);
                break;
              }
            }
          }
        }
      }
    }

    if (move == PLAY_DOWN) {
      for (int x = 0; x < x_dim; ++x) {
        for (int y = y_dim - 1; y > 0; --y) {
          if (grid.getTile(x, y).getValue() == 0) {
            for (int dy = y; dy >= 0; --dy) {
              if (grid.getTile(x, dy).getValue() != 0) {
                grid.getTile(x, y).setValue(grid.getTile(x, dy).getValue());
                grid.getTile(x, dy).setValue(0);
                for (int ddy = dy; ddy >= 0; --ddy) {
                  if (grid.getTile(x, ddy).getValue() == grid.getTile(x, y).getValue()) {
                    grid.getTile(x, y).increment();
                    grid.getTile(x, ddy).setValue(0);
                    break;
                  }
                }
                break;
              }
            }
          } else {
            for (int ddy = y - 1; ddy >= 0; --ddy) {
              if (grid.getTile(x, ddy).getValue() == grid.getTile(x, y).getValue()) {
                grid.getTile(x, y).increment();
                grid.getTile(x, ddy).setValue(0);
                break;
              }
            }
          }
        }
      }
    }



    if (move == PLAY_LEFT) {
      for (int y = 0; y < y_dim; ++y) {
        for (int x = 0; x < x_dim - 1; ++x) {
          if (grid.getTile(x, y).getValue() == 0) {
            for (int dx = x; dx <= x_dim - 1; ++dx) {
              if (grid.getTile(dx, y).getValue() != 0) {
                grid.getTile(x, y).setValue(grid.getTile(dx, y).getValue());
                grid.getTile(dx, y).setValue(0);
                for (int ddx = dx; ddx <= x_dim - 1; ++ddx) {
                  if (grid.getTile(ddx, y).getValue() == grid.getTile(x, y).getValue()) {
                    grid.getTile(x, y).increment();
                    grid.getTile(ddx, y).setValue(0);
                    break;
                  }
                }
                break;
              }
            }
          } else {
            for (int ddx = x + 1; ddx <= x_dim - 1; ++ddx) {
              if (grid.getTile(ddx, y).getValue() == grid.getTile(x, y).getValue()) {
                grid.getTile(x, y).increment();
                grid.getTile(ddx, y).setValue(0);
                break;
              }
            }
          }
        }
      }
    }

    if (move == PLAY_RIGHT) {
      for (int y = 0; y < y_dim; ++y) {
        for (int x = x_dim - 1; x > 0; --x) {
          if (grid.getTile(x, y).getValue() == 0) {
            for (int dx = x; dx >= 0; --dx) {
              if (grid.getTile(dx, y).getValue() != 0) {
                grid.getTile(x, y).setValue(grid.getTile(dx, y).getValue());
                grid.getTile(dx, y).setValue(0);
                for (int ddx = dx; ddx >= 0; --ddx) {
                  if (grid.getTile(ddx, y).getValue() == grid.getTile(x, y).getValue()) {
                    grid.getTile(x, y).increment();
                    grid.getTile(ddx, y).setValue(0);
                    break;
                  }
                }
                break;
              }
            }
          } else {
            for (int ddx = x - 1; ddx >= 0; --ddx) {
              if (grid.getTile(ddx, y).getValue() == grid.getTile(x, y).getValue()) {
                grid.getTile(x, y).increment();
                grid.getTile(ddx, y).setValue(0);
                break;
              }
            }
          }
        }
      }
    }

    _last_move = move;
    if (!legal) {
      _last_status = ILLEGAL_MOVE;
      return ILLEGAL_MOVE;
    }

    if (create_random()) {
      _moves++;
      print("played:" + _moves + "\n");
      _last_status = CONTINUE;
      return CONTINUE;
    } else {
      _last_status = END;
      return END;
    }
  }

  CGame(boolean visible) {
    //create_random();
    if (visible) {
      draw(800, 800);
    } else {
    }
  }

  void draw(int dim_x, int dim_y) {
    grid.draw(dim_x, dim_y);
  }
};
