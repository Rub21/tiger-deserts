/*Map {
 background-color: #144;
}

#countries {
  ::outline {
    line-color: #85c5d3;
    line-width: 2;
    line-join: round;
  }
  polygon-fill: #fff;
}*/

@1: #D6F0FD;
@2: #8BD7F9;
@3: #30BEF6;
@4: #008FC4;
@5: #006186;

#grid{
  



[amo_v1 >0]  [amo_v1<=3]  {
     polygon-opacity:0.8;
    polygon-fill: @1;
  }
   [amo_v1>3][amo_v1<= 6]  {
     polygon-opacity:0.8;
    polygon-fill: @2;
  }
    [amo_v1>6][amo_v1<=9] {
     polygon-opacity:0.8;
    polygon-fill: @3;
  }
     [amo_v1>9][amo_v1<= 12] {
     polygon-opacity:0.8;
    polygon-fill: @4;
  }
   [amo_v1>12]{
     polygon-opacity:0.8;
    polygon-fill: @5;
  }
  }
  
  
  
  
  
  
  
  
  