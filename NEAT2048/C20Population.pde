class CPopulation {
    int generation_number;
  
    int _size;
    CNetwork[] old_generation;
    CNetwork[] generation;

    ArrayList<CSpecies> old_species;
    ArrayList<CSpecies> species;
    
    double[] fitness_prob;
    
    void new_generation(){
      //move old generation
      old_generation = generation;
      //move old species;
      for (CSpecies spec : species){
        print(spec.members.size() + " ");
      }
      print("\n");
      //print("old_species:" + old_species.size());
      old_species = species;
      print("species:" + species.size() + "\n");
      print("old_species:" + old_species.size() + "\n");
      species = new ArrayList<CSpecies>();
      print("species:" + species.size() + "\n");
      print("old_species:" + old_species.size() + "\n");
      /*for (int i = 0; i < old_species.size(); ++i){
        species.add(new CSpecies(old_species.get(i).members.get(0)));
      }*/
      
      
      //create new generation
      create_new_generation();
      generation_number++;
    }
    
    CPopulation(int size){
      _size = size;
      old_generation = new CNetwork[_size];
      generation = new CNetwork[_size];
    }
    
    void create_new_generation(){
      int created_networks = 0;
      
      adjust_fitness_to_species();
      prepare_fitness_prob(_size);
      
      generation = new CNetwork[_size];
      
      for (int i = created_networks; i < _size; ++i){
        CNetwork parent1 = select_random_network_on_fitness();
        CNetwork parent2 = select_random_network_on_fitness();
        generation[created_networks++] = parent1.createOffspring(parent2);
        //print(parent1.UID + " " + parent2.UID + " -> " + generation[created_networks-1].UID + "\n");
      }
      
      for (CNetwork network : generation){
        if (random(3) > 2){
          network.mutate();
        }
      }
      speciate_generation();
    }
    
    void first_generation(){
      //create members
      println("_size:" + _size);
      for (int i = 0; i < _size; ++i){
        generation[i] = new CNetwork(false);
      }
      //speciate
      species = new ArrayList<CSpecies>();
      species.add(new CSpecies(generation[0]));
      for (CNetwork network : generation){
        species.get(0).add_member(network);
      }
      generation_number = 1;
    }
    
    void speciate_generation(){
      for (CNetwork network : generation){
        boolean added_spec = false;
        for (CSpecies old_spec : old_species){
          boolean species_exists = false;
          if (old_spec.is_in_species(network)){
            for (CSpecies spec : species){
              if (spec == old_spec){
                species_exists = true;
                spec.add_member(network);
                added_spec = true;
                break;
              }
            }
            if (!species_exists){
              //transfer old species
              species.add(new CSpecies(old_spec._UID, old_spec.prototype));
              species.get(species.size() - 1).add_member(network);
              added_spec = true;
            } else {
              break;
            }
          }
          if (species_exists){
            break;
          } 
        }
        for (CSpecies new_spec : species){
          if (new_spec.is_in_species(network)){
            new_spec.add_member(network);
            added_spec = true;
            break;
          }
        }
        if (!added_spec){
          //create new species
          species.add(new CSpecies(network));
        }
      }
    }
    
    
    void adjust_fitness_to_species(){
      println("adjusting fitness to species");
      for (CSpecies spec : species){
        int size = spec.get_size();
        for (CNetwork network : spec.members){
          network._fitness = network._fitness / size;
        }
      }
    }
    void prepare_fitness_prob(int _size){
      fitness_prob = new double[_size];
      fitness_prob[0] = old_generation[0].getFit();
      for (int i = 1; i < _size; ++i){
        fitness_prob[i] = old_generation[i].getFit() + fitness_prob[i-1];
      }
    }
    
    //returns a random network using fitness as their probability
    CNetwork select_random_network_on_fitness(){
      double network_rnd = (double)random((float)fitness_prob[_size-1]);
      for (int i = 0; i < _size; ++i){
        if (network_rnd < fitness_prob[i]){
          return  old_generation[i];
        }
      }
      return old_generation[_size];
    }
}
