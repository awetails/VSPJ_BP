class CSpecies {
    CNetwork prototype;

    ArrayList<CNetwork> members;
    
    CSpecies(CNetwork prot){
       prototype = prot;
    }
    
    void add_member(CNetwork member){
      members.add(member);
    }
    
    int get_size(){
      return members.size();
    }
    
    boolean is_in_species(CNetwork network, float treshold = 3.0){
      return treshold >= genetic_distance(network, prototype);
    }
    
    CNetwork get_most_fit_member(){
      CNetwork highest = members.get(0);
      for (CNetwork net : members){
        if (net._fitness > highest._fitness){
          highest = net;
        }
      }
    }
    
}

float genetic_distance(CNetwork left, CNetwork right){
  CNetwork high, low;
  int low_max_innovation;
  if (left.get_highest_innovation() > right.get_highest_innovation()){
    high = left;
    low = right;
    low_max_innovation = right.get_highest_innovation();
  } else {
    high = right;
    low = left;
    low_max_innovation = left.get_highest_innovation();
  }
  
  IntList high_innovations = new IntList();
  for (CConnection conn : high._connections){
    high_innovations.append(conn._innovation);
  }
  
  IntList low_innovations = new IntList();
  for (CConnection conn : low._connections){
    low_innovations.append(conn._innovation);
  }
  
  high_innovations.sort();
  low_innovations.sort();
  
  int param_E = 0;
  int param_D = 0;
  float param_W = 0;
  int number_of_W = 0;
  
  
  int high_i = 0;
  int low_i = 0;
  while (high_i < high_innovations.size() || low_i < low_innovations.size()){
    if (low_i < low_innovations.size()){
      ++param_E;
      ++high_i;
      continue;
    }
    if (high_innovations.get(high_i) == low_innovations.get(low_i)){
      //matching gene
      CConnection high_conn = high.findCConnectionByInnovation(high_i);
      CConnection low_conn = low.findCConnectionByInnovation(low_i);
      param_W += abs(high_conn._weight - low_conn._weight)/2.0;
      ++number_of_W;
      ++high_i;
      ++low_i;
      continue;
    }
    
    if (high_innovations.get(high_i) > low_innovations.get(low_i)){
      //disjoint
      ++param_D;
      ++low_i;
    } else {
      //disjoint
      ++param_D;
      ++high_i;
    }
  }
  float param_c1 = 1.0;
  float param_c2 = 1.0;
  float param_c3 = 0.4;
  float param_N = 1;
  
  param_W /= number_of_W;
  
  return ((param_c1*param_E)/param_N) + ((param_c2*param_D)/param_N) + (param_c3*param_W);
}
