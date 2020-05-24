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

int gene_number = 0;

CGene createCGene(){
  return new CGene(++gene_number,0.0);
}

CGene createCGene(float treshold){
  return new CGene(++gene_number,treshold);
}
