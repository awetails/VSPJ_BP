class CPopulation {
    int _size;
    CNetwork[] old_generation;
    CNetwork[] generation;

    ArrayList<CSpecies> old_species;
    ArrayList<CSpecies> species;
    
    void new_generation(){
      //move old generation
      old_generation = generation;
      //move old species; 
      old_species = species;
      species = new ArrayList<CSpecies>();
      for (int i = 0; i < old_species.size(); ++i){
        species.add(new CSpecies(old_species.get(i).members.get(0)));
      }
      //create new generation
      create_new_generation();
      
    }
    
    CPopulation(int size){
      _size = size;
      old_generation = new CNetwork[_size];
      generation = new CNetwork[_size];
    }
    
    void create_new_generation(){
      int created_networks = 0;
      //preserve species
      for (CSpecies spec : old_species){
        generation[created_networks++] = spec.get_most_fit_member();
      }
      
    }
    
    void first_generation(){
      //create members
      println("_size:" + _size);
      for (int i = 0; i < _size; ++i){
        generation[i] = new CNetwork(false);
        println("i:" + i);
      }
      //speciate
      species = new ArrayList<CSpecies>();
      species.add(new CSpecies(generation[0]));
      for (CNetwork network : generation){
        species.get(0).add_member(network);
      }
    }
    
    void speciate_generation(){
      for (CNetwork network : generation){
        //boolean assigned = false;
        for (CSpecies spec : species){
          if (spec.is_in_species(network)){
            spec.add_member(network);
          } else {
            species.add(new CSpecies(network));
          }
          
        }
      }
    }
    
    void adjust_fitness_to_species(){
      for (CSpecies spec : species){
        int size = spec.get_size();
        for (CNetwork network : spec.members){
          network._fitness = network._fitness / size;
        }
      }
    }
    
}
