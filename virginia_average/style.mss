Map {
  background-color: #b8dee6;
}

#countries {
  ::outline {
    line-color: #85c5d3;
    line-width: 2;
    line-join: round;
  }
  polygon-fill: #fff;
}

@1: #D6F0FD;
@2: #8BD7F9;
@3: #30BEF6;
@4: #008FC4;
@5: #006186;

#grid{

  [average_v >=0]  [average_v<=1.074]  {
     polygon-opacity:0.7;
    polygon-fill: @5;
  }
   [average_v>1.074][average_v<= 1.148]  {
     polygon-opacity:0.7;
    polygon-fill: @4;
  }
    [average_v>1.148][average_v<=1.222] {
     polygon-opacity:0.7;
    polygon-fill: @3;
  }
     [average_v>1.222][average_v<=1.296] {
     polygon-opacity:0.7;
    polygon-fill: @2;
  }
   [average_v>1.296] {
     polygon-opacity:0.7;
    polygon-fill: @1;
  }
  

  
  }
