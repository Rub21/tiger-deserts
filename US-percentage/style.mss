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
[perc_v1 >0]  [perc_v1<=60]  {
    polygon-opacity:0.8;
    polygon-fill: @1;
  }
   [perc_v1>60][perc_v1<=70]  {
     polygon-opacity:0.8;
    polygon-fill: @2;
  }
    [perc_v1>70][perc_v1<=80] {
     polygon-opacity:0.8;
    polygon-fill: @3;
  }
     [perc_v1>80][perc_v1<= 90] {
     polygon-opacity:0.8;
    polygon-fill: @4;
  }
   [perc_v1>90][perc_v1<=100] {
     polygon-opacity:0.8;
    polygon-fill: @5;
  }
}
  