class CNetwork {

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
        for (int i = 0; i < 16; ++i){
          _genes_input.add(createCGene());
        }
        for (int i = 0; i < 2; ++i){
          _genes_output.add(createCGene());
        }
        for (int input = 0; input < 16; ++input){
          for (int output = 0; output < 2; ++output){
            createCConnection(_genes_input.get(input),_genes_output.get(output));
          }
        }
      }
    }
    
    void setInput(CGrid input){
      for (int i = 0; i < 16; ++i){
        _genes_input.get(i)._value = input.getLinear(i);
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
      }
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
      _genes_hidden.get(int(random(_genes_hidden.size()))).mutate_random();
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
      CGene gene = createCGene();
      CConnection conn_new_out = createCConnection(gene, conn._out, conn._weight);
      CConnection conn_new_in = createCConnection(conn._in, gene);
      conn._weight = 0;
      _genes_hidden.add(gene);
      _connections.add(conn_new_out);
      _connections.add(conn_new_in);
    }
    

    //changes weight treshold or creates new nodes or connections  
    void mutate(){
      for (int i = 0; i < 5; ++i){
        switch(int(random(4))){
          case MUTATE_WEIGHT:
            _mutate_random_connection();
            break;
          case MUTATE_TRESHOLD:
            _mutate_random_gene();
            break;
          case ADD_NODE:
            _mutate_add_random_gene();
            break;
          case ADD_CONNECTION:
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
