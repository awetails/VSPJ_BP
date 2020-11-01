CGame game;
PFont myFont;
boolean done = false;
boolean done2 = false;
int time,time2;

CEvolutionManager manager;


void setup(){
    size(800,800);
    myFont = createFont("Georgia", 32);
    textFont(myFont);
    textAlign(CENTER, CENTER);
    
    manager = new CEvolutionManager(CEvolutionManager.THOUSAND_GAMES);
    
    CPopulation population = new CPopulation(100);
    population.first_generation();
    
    
    CNetwork network = new CNetwork(false);
    
    
    
    manager.evaluate(network);
    
    print("fitness:" + network.getFit());
    
    _wait(10);
    game = new CGame(true);
    game.create_random();
    print(game.play(1));
    time = millis() + 3000;
}

void draw(){
  background(255,255,255);
  game.draw(800,800);
  if (done != true && time < millis()){
    game.play(floor(random(4)));
    game.draw(800,800);
    _wait(1);
    game.create_random();
    time = time + 3000;
    //done = true;
  }

}
