class CNetwork {
  
    String UID;

    ArrayList<CGene> _genes_input;
    ArrayList<CGene> _genes_output;
    ArrayList<CGene> _genes_hidden;

    ArrayList<CConnection> _connections;

    double _fitness = INVALID_FITNESS;
    static final int INVALID_FITNESS = -1;
    
    
    static final int MUTATE_WEIGHT   = 0;
    static final int MUTATE_TRESHOLD = 1;
    static final int ADD_NODE        = 2;
    static final int ADD_CONNECTION  = 3;
    

    CNetwork(boolean empty){
      UID = "N:";
      for (int i = 0; i < 5; ++i){
        UID += char(int(random(65,122)));
      }
      if (empty){
        _genes_input = new ArrayList<CGene>();
        _genes_output = new ArrayList<CGene>();
        _genes_hidden = new ArrayList<CGene>();
        _connections = new ArrayList<CConnection>();
      } else {
        //new network consist of connections of all input genes to all output genes
        _genes_input = new ArrayList<CGene>();
        _genes_output = new ArrayList<CGene>();
        _genes_hidden = new ArrayList<CGene>();
        _connections = new ArrayList<CConnection>();
        int gene_i = 1;
        for (; gene_i <= 4*4*12; ++gene_i){ //each number has its own descreet state
          _genes_input.add(new CGene(gene_i, 0.0));
        }
        int input_nodes = gene_i++;
        println("input_nodes:" + input_nodes);
        for (; gene_i <= input_nodes + 2; ++gene_i){
          _genes_output.add(new CGene(gene_i, 0.0));
        }
        gene_number = gene_i;
        int output_nodes = gene_i - input_nodes;
        println("output_nodes:" + output_nodes);
        for (int input = 0; input < input_nodes - 1; ++input){
          println("input:" + input);
          for (int output = 0; output < output_nodes - 1; ++output){
            println("output:" + output);
            _connections.add(createWeightCConnection(_genes_input.get(input),_genes_output.get(output),0));
          }
        }
        println("_genes_input:" + _genes_input.size() + " " + _genes_input);
        println("_genes_output:" + _genes_output.size() + " " + _genes_output);
      }
    }
    
    void setInput(CGrid input){
      int tile_number = input._dim_x * input._dim_y;
      for (int tile_i = 0; tile_i < tile_number; ++tile_i){
        float __value = input.getLinear(tile_i);
        for (int value_i = 0; value_i < 12; ++value_i){
          if (__value == 0){
            _genes_input.get((tile_i * 12) + value_i)._value = 1;
            break;
          }
          __value /= 2;
        }
      }
      for (int i = 0; i < tile_number * 12; ++i){
        _genes_input.get(i)._status = CGene.COMPUTED;
      }
    }
    
    boolean checkConnection(CGene in, CGene out){
      for (int i = 0; i < _connections.size(); ++i){
        if (in == _connections.get(i)._in && out == _connections.get(i)._out){
          return true;
        }
      }
      return false;
    }

    /**
    returns bitmask of active output nodes
    */
    int compute(CGrid input){
      for (CGene gene : _genes_input){
        gene.reset();
      }
      for (CGene gene : _genes_output){
        gene.reset();
      }
      for (CGene gene : _genes_hidden){
        gene.reset();
      } 
      
      setInput(input);
      
      for (CGene output_gene : _genes_output){
        output_gene.compute();
        if (population.generation_number > slow_after) print(output_gene.getValue() + " ");
      }
      if (population.generation_number > slow_after) print("\n");
      int out = 0;
      for (int i = 0; i < _genes_output.size(); ++i){
        if (_genes_output.get(i).getValue() > 0){
          out += pow(2,i);
        }
      }
      return out;
    }
    
    
    void _mutate_random_connection(){
      _connections.get(int(random(_connections.size()))).mutate_random();
    }
    
    void _mutate_random_gene(){
      if (_genes_hidden.size() != 0){
        _genes_hidden.get(int(random(_genes_hidden.size()))).mutate_random();
      }
    }
    
    void _mutate_add_random_connection(){
      IntList in_genes = new IntList();
      for (int i = 0; i < _genes_input.size() + _genes_hidden.size(); ++i){
        in_genes.append(i);
      }
      in_genes.shuffle();
      
      IntList out_genes = new IntList();
      for (int i = 0; i < _genes_output.size() + _genes_hidden.size(); ++i){
        out_genes.append(i);
      }
      out_genes.shuffle();
      
      for (int i = 0; i < in_genes.size(); ++i){
        for (int j = 0; j < out_genes.size(); ++j){
          int mode = 0;
          if (in_genes.get(i) >= _genes_input.size()){
            mode += 1;
          }
          if (out_genes.get(j) >= _genes_output.size()){
            mode += 2;
          }
          CGene in, out;
          switch (mode){
            case 0:
              in = _genes_input.get(in_genes.get(i));
              out = _genes_output.get(out_genes.get(j));
              break;
            case 1:
              in = _genes_hidden.get(in_genes.get(i) - _genes_input.size());
              out = _genes_output.get(out_genes.get(j));
              break;
            case 2:
              in = _genes_input.get(in_genes.get(i));
              out = _genes_hidden.get(out_genes.get(j) - _genes_output.size());
              break;
            case 3:
              in = _genes_hidden.get(in_genes.get(i) - _genes_input.size());
              out = _genes_hidden.get(out_genes.get(j) - _genes_output.size());
              break;
            default:
              in = null;
              out = null;
          }
          if (!checkConnection(in, out)){
            CConnection conn = createCConnection(in, out);
            _connections.add(conn);
          }
        }
      }
    }
    
    void _mutate_add_random_gene(){
      CConnection conn = _connections.get(int(random(_connections.size())));
      CGene gene = createCGene(conn);
      //CConnection conn_new_out = createCConnection(gene, conn._out, conn._weight);
      //CConnection conn_new_in = createCConnection(conn._in, gene);
      //conn._weight = 0;
      _genes_hidden.add(gene);
      _connections.add(gene._input.get(0));
      _connections.add(gene._output.get(0));
      conn._weight = 0; //disables the original connection
    }
    

    //changes weight treshold or creates new nodes or connections  
    void mutate(){
      float[] mutation_probabilities = {10.0, 20.0, 21.0, 22.0};
      int mutate_choice=0;
      for (int i = 0; i < 5; ++i){
        float prob_rnd = random(mutation_probabilities[mutation_probabilities.length - 1]);
        for (int prob_i = 0; prob_i < mutation_probabilities.length; ++prob_i){
          if (prob_rnd < mutation_probabilities[prob_i]){
            mutate_choice = prob_i;
            break;
          }
        }
        switch(mutate_choice){
          case MUTATE_WEIGHT:
            //print(UID + ":MUTATE_WEIGHT\n");
            _mutate_random_connection();
            break;
          case MUTATE_TRESHOLD:
            //print(UID + ":MUTATE_TRESHOLD\n");
            _mutate_random_gene();
            break;
          case ADD_NODE:
            //print(UID + ":ADD_NODE\n");
            _mutate_add_random_gene();
            break;
          case ADD_CONNECTION:
            //print(UID + ":ADD_CONNECTION\n");
            _mutate_add_random_connection();
            break;
        }
      }
      
    }
    
    CNetwork createOffspring(CNetwork net){
      CNetwork offspring = new CNetwork(true); //create empty network
      CNetwork stronger, weaker;
      if (this.getFit() < net.getFit()){
        stronger = net;
        weaker = this;
      } else {
        stronger = this;
        weaker = net;
      }
      
      ArrayList<CConnection> stronger_unique = new ArrayList<CConnection>();
      ArrayList<CConnection> both = new ArrayList<CConnection>();
      
      //get unique connection from the stronger network
      for (CConnection strong_conn : stronger._connections){
        boolean in_weak = false;
        for (CConnection weak_conn : weaker._connections){
          if (strong_conn == weak_conn){
            if (floor(random(2)) == 1){
              both.add(strong_conn);
            } else {
              both.add(weak_conn);
            }
            in_weak = true;
            break;
          }
        }
        if (in_weak){
          continue;
        }
        stronger_unique.add(strong_conn);
      }
      
      for (CConnection conn : stronger_unique){
        offspring._connections.add(conn);
      }
      
      for (CConnection conn : both){
        offspring._connections.add(conn);
      }
      
      //reconstruct nodes
      IntList usedgenes = new IntList();
      for (CGene gene : stronger._genes_input){
        offspring._genes_input.add(gene);
        usedgenes.append(gene._innovation);
      }
      for (CGene gene : stronger._genes_output){
        offspring._genes_output.add(gene);
        usedgenes.append(gene._innovation);
      }
      
      for (CConnection conn : offspring._connections){
        if (usedgenes.hasValue(conn._in._innovation) || usedgenes.hasValue(conn._out._innovation)){
          continue;
        }
        if (conn._in._innovation == conn._out._innovation){
          offspring._genes_hidden.add(conn._in);
          usedgenes.append(conn._in._innovation);
        }
        if (!usedgenes.hasValue(conn._in._innovation)){
          offspring._genes_hidden.add(conn._in);
          usedgenes.append(conn._in._innovation);
        } else {
          offspring._genes_hidden.add(conn._out);
          usedgenes.append(conn._out._innovation);
        }
      }
      return offspring;
    }
    
    double getFit(){
      return _fitness;
    }
    void setFit(double fitness){
      _fitness = fitness;
    }
    void nullFit(){
      _fitness = INVALID_FITNESS;
    }
    
    int get_highest_innovation(){
      int max;
      max = _connections.get(0)._innovation;
      for (CConnection conn : _connections){
        if (conn._innovation > max){
          max = conn._innovation;
        }
      }
      return max;
    }
    
    CConnection findCConnectionByInnovation(int innovation){
      for (CConnection conn : _connections){
        if (conn._innovation == innovation){
          return conn;
        }
      }
      return null;
    }
    
}
