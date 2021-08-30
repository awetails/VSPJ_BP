class CConnection {
    CGene _in;
    CGene _out;

    float _weight;
    int _innovation;
    
    CConnection(CGene in, CGene out, int innovation, float weight){
      _in = in;
      _out = out;
      _innovation = innovation;
      _weight = weight;
    }
    
    void mutate_random(){
      _weight += randomGaussian();
    }
}

class ConnectionPrimitive{
  int _in;
  int _out;
  int _innovation;
  
  ConnectionPrimitive(int in, int out, int innovation){
    _in = in;
    _out = out;
    _innovation = innovation;
  }
}

int innovation_number = 0;

ArrayList<ConnectionPrimitive> connection_pool = new ArrayList<ConnectionPrimitive>();

CConnection createCConnection(CGene in, CGene out){
  //check if trait already exists in the pool
  for (ConnectionPrimitive conn : connection_pool){
    if (conn._in == in._innovation && conn._out == out._innovation){
      CConnection new_conn = new CConnection(in, out, conn._innovation, 1);
      in.addOutput(new_conn);
      out.addInput(new_conn);
      return new_conn;
    }
  }
  //no connection exists new must be created
  int new_innovation_number = ++innovation_number;
  CConnection new_conn = new CConnection(in, out, new_innovation_number, 1);
  in.addOutput(new_conn);
  out.addInput(new_conn);
  connection_pool.add(new ConnectionPrimitive(in._innovation, out._innovation, new_innovation_number));
  return new_conn;
}

CConnection createWeightCConnection(CGene in, CGene out, float weight){
  //check if trait already exists in the pool
  for (ConnectionPrimitive conn : connection_pool){
    if (conn._in == in._innovation && conn._out == out._innovation){
      CConnection new_conn = new CConnection(in, out, conn._innovation, weight);
      in.addOutput(new_conn);
      out.addInput(new_conn);
      return new_conn;
    }
  }
  //no connection exists new must be created
  CConnection new_conn = new CConnection(in, out, ++innovation_number, weight);
  in.addOutput(new_conn);
  out.addInput(new_conn);
  return new_conn;
}

CConnection createCConnection(CGene in, CGene out, float weight){
  CConnection conn =  new CConnection(in, out, ++innovation_number, weight);
  in.addOutput(conn);
  out.addInput(conn);
  return conn;
}
