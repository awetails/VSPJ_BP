class CGene {
    ArrayList<CConnection> _input;
    ArrayList<CConnection> _output;
  
  
    float _treshold;
    int _innovation;
    
    float _value;
    
    static final int IDLE = 0;
    static final int COMPUTING = 1;
    static final int COMPUTED = 2;
    
    int _status;
    
    CGene(int innovation, float treshold){
      _innovation = innovation;
      _treshold = treshold;
      
      _input = new ArrayList<CConnection>();
      _output = new ArrayList<CConnection>();
      
    }
    
        void mutate_random(){
      _treshold += randomGaussian();
    }
    
    void compute(){
      _value = 0;
      _status = COMPUTING;
      for (CConnection input_conn : _input){
        if (input_conn._in.getStatus() == COMPUTING){
          //cycle - disregard
          continue;
        }
        if (input_conn._in.getStatus() == IDLE){
          input_conn._in.compute();
        }
        if (input_conn._in.getStatus() == COMPUTED){
          _value += input_conn._in._value * input_conn._weight;
        }
      }
      _status = COMPUTED;
    }
    
    void reset(){
      _status = IDLE;
    }
    
    float getValue(){
      if (_value >= _treshold){
        return _value;
      } else {
        return 0;
      }
    }
    
    int getStatus(){
      return _status;
    }
    
    void addInput(CConnection input_connection){
      _input.add(input_connection);
    }
    
    void addOutput(CConnection output_connection){
      _output.add(output_connection);
    }
    
}

class GenePrimitive{
  int _target;
  int _innovation;
  
  GenePrimitive(int target, int innovation){
    _target = target;
    _innovation = innovation;
  }
}


int gene_number = 0;

ArrayList<GenePrimitive> gene_pool = new ArrayList<GenePrimitive>();

CGene createCGene(CConnection target){
  for (GenePrimitive gene : gene_pool){
    if (target._innovation == gene._innovation){
      CGene new_gene = new CGene(gene._innovation, 0);
      CConnection conn_new_out = createWeightCConnection(new_gene, target._out, target._weight);
      CConnection conn_new_in = createWeightCConnection(target._in, new_gene, 1);
      new_gene._input.add(conn_new_in);
      new_gene._output.add(conn_new_out);
      return new_gene;
    }
  }
  int new_gene_number = ++gene_number;
  CGene new_gene = new CGene(new_gene_number, 0);
  gene_pool.add(new GenePrimitive(target._innovation, new_gene_number));
  CConnection conn_new_out = createWeightCConnection(new_gene, target._out, target._weight);
  CConnection conn_new_in = createWeightCConnection(target._in, new_gene, 1);
  new_gene._input.add(conn_new_in);
  new_gene._output.add(conn_new_out);
  return new_gene;
}

CGene createCGene(){
  return new CGene(++gene_number,0.0);
}

CGene createCGene(float treshold){
  return new CGene(++gene_number,treshold);
}
