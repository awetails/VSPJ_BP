class CEvolutionManager {

  static final int THOUSAND_GAMES = 0;

  int _mode;

  CEvolutionManager(int mode) {
    switch(mode) {
    case THOUSAND_GAMES:
      _mode = THOUSAND_GAMES;

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
    while (true){
      int move_result = game.play(network.compute(game.grid));
      if (move_result == CGame.END || move_result == CGame.ILLEGAL_MOVE)
      {
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
      fitness += thousand_games_fitness(game) / 1000; //get average
      //print("games played:" + i + "\n");
    }
    network.setFit(fitness);
  }


  void evaluate(CNetwork network) {
    switch(_mode){
      case THOUSAND_GAMES:
      thousand_games(network);
      break;
      
      }
  }
}
