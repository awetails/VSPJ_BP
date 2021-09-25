CGame game;
PFont myFont;
boolean done = false;
boolean done2 = false;
int time,time2;

CEvolutionManager manager;
CPopulation population;
int slow_after;

CGame active_game;

void setup(){
    size(800,800);
    myFont = createFont("Georgia", 32);
    textFont(myFont);
    textAlign(CENTER, CENTER);
    
    randomSeed(1);
    slow_after = 0;
    
    manager = new CEvolutionManager(CEvolutionManager.THOUSAND_GAMES);
    
    population = new CPopulation(5000);
    population.first_generation();
    print("\n\n----------------\nGENERATION: " + population.generation_number + "\n----------------\n");
    print("innovation_number:" + innovation_number + "\n");
    print("\n");
    
    //CNetwork network = new CNetwork(false);
    
    
    
    //manager.evaluate(network);
    
    //print("fitness:" + network.getFit());
    noLoop();
    _wait(5);
    //game = new CGame(true);
    //game.create_random();
    //print(game.play(1));
    //time = millis() + 3000;
    main_loop();
}

void main_loop(){
  while (true){

  //game.draw(800,800);
  /*if (done != true && time < millis()){
    int play=floor(random(4));
    game.play(play);
    game.draw(800,800);
    _wait(1);
    game.create_random();
    time = time + 300;
    //done = true;
    
   
  }*/
  //CNetwork[] top = new CNetwork[5];
  //int top_number = 0;
  double[] top_fitness = {0,0,0,0,0};
  for (CNetwork network : population.generation){
    manager.evaluate(network);
    //print("network:" + network.UID + " " + network._genes_hidden.size() + " " + network._connections.size() + " " + network.getFit() + "\n");
    /*if (top_number++ < 5){
      top[top_number] = network;
    } else {*/
      for (int i = 0; i < 5; ++i){
        if (network.getFit() > top_fitness[i]){
          top_fitness[i] = network.getFit();
          break;
        }
      }
    }   
  println(top_fitness);
  
  population.new_generation();
  
  /*for (ConnectionPrimitive cp : connection_pool){
    print("CONN: " + cp._innovation + " " + cp._in + " " + cp._out + "\n");
  }*/
  
  print("\n\n----------------\nGENERATION: " + population.generation_number + "\n----------------\n");
  print("innovation_number:" + innovation_number + "\n");
  println("species:" + population.species.size());
  println("old_species:" + population.old_species.size());
  print("\n");
  }
}

void draw(){
  println("drawing");
      background(255,255,255);
           fill(255,0,0);
         rect(10,10, 100, 100);
         active_game.draw(800,800); //<>//

}
