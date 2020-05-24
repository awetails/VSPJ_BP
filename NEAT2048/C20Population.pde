class CPopulation {
    int _size;
    CNetwork[] old_generation;
    CNetwork[] generation;

    ArrayList<CSpecies> species;
    
    void new_generation(){
      for (int i = 0; i < _size; ++i){
        old_generation[i] = generation[i];
        generation[i] = null;
      }
    }
    
    CPopulation(int size){
      _size = size;
      old_generation = new CNetwork[_size];
      generation = new CNetwork[_size];
    }
    
    void first_generation(){
      for (int i = 0; i < _size; ++i){
        generation[0] = new CNetwork(false);
      }
    }
    
    void adjust_fitness_to_species(){
      for (CSpecies spec : species){
        for (CNetwork network : spec.members){
          
        }
      }
    }
    
}
