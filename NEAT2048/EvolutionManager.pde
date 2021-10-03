class CEvolutionManager {

  static final int THOUSAND_GAMES = 0;
  static final int HIGHEST_OF_TEN = 1;
  static final int LONGEST_OF_TEN = 2;

  int _mode;

  CEvolutionManager(int mode) {
    switch(mode) {
    case THOUSAND_GAMES:
      _mode = THOUSAND_GAMES;
      break;
    case HIGHEST_OF_TEN:
      _mode = HIGHEST_OF_TEN;
      break;
    case LONGEST_OF_TEN:
      _mode = LONGEST_OF_TEN;
      break;

    default:
      _mode = THOUSAND_GAMES;
    }
  }


  //based on game returns fitness
  double thousand_games_fitness(CGame game) {
    return ((double)(5 * game.get_highest()) + (3 * game._moves));
  }

  CGame play_game(CNetwork network){
    CGame game = new CGame(false);
    active_game = game;
    if (population.generation_number > slow_after){
      println(game.grid.getGridText());
      
    }
    while (true){
      int move = network.compute(game.grid);
      int move_result = game.play(move);
      if (population.generation_number > slow_after){
        switch (move){
          case CGame.PLAY_UP:
            println("UP");
            break;
          case CGame.PLAY_DOWN:
            println("DOWN");
            break;
          case CGame.PLAY_LEFT:
            println("LEFT");
            break;
          case CGame.PLAY_RIGHT:
            println("RIGHT");
            break;
        }
        println(game.grid.getGridText());
        redraw();
        _wait(1);
      }
        if (move_result == CGame.END || move_result == CGame.ILLEGAL_MOVE){
          if (population.generation_number > slow_after){
            switch (move_result){
            case CGame.END:
              println("END");
              break;
            case CGame.ILLEGAL_MOVE:
              println("ILLEGAL_MOVE");
              break;
            }
          }
          
          break;
        }
      
    }
    
    return game;
  }
  
  
  //procedures
  void thousand_games(CNetwork network){
    double fitness = 0;
    for (int i = 0; i < 1000; ++i){
      CGame game = play_game(network);
      //print("\n");
      fitness += thousand_games_fitness(game) / 1000; //get average
      //print("games played:" + i + "\n");
    }
    network.setFit(fitness);
  }
  
  void highest_of_ten(CNetwork network){
    double fitness = 0;
    for (int i = 0; i < 10; ++i){
      CGame game = play_game(network);
      int highest = game.get_highest();
      if (highest > fitness){
        fitness = highest;
      }
    }
    network.setFit(pow(2,(float)fitness));
  }

  void longest_of_ten(CNetwork network){
    double fitness = 0;
    for (int i = 0; i < 10; ++i){
      CGame game = play_game(network);
      int longest = game.get_highest();
      if (longest > fitness){
        fitness = longest;
      }
    }
    network.setFit(pow(1.5,(float)fitness));
  }


  void evaluate(CNetwork network) {
    switch(_mode){
      case THOUSAND_GAMES:
      thousand_games(network);
      break;
      case HIGHEST_OF_TEN:
      highest_of_ten(network);
      break;
      case LONGEST_OF_TEN:
      highest_of_ten(network);
      break;
      
      }
  }
}
