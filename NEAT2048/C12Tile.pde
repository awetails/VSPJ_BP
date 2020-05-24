class CTile{
    int _val;
    CTile(){
        _val = 0;
    }

    int getValue(){
        return _val;
    }

    void setValue(int val){
        _val = val;
    }

    void increment(){
        _val++;
    }

    void draw(int x, int y, int dim_x, int dim_y){
        fill(0,255,0);
        rect(x,y,dim_x,dim_y);
        fill(0,0,0);
        if (_val > 0){
          text("2^" + _val, x + dim_x/2, y + dim_y/2);
        }
    }
}
