$fn=50;

widthTop=20; //this is the width of the upper plank; set as you wish



minkowskiRadius=2;
minkowskiThick=2;

connectorWidth=5;
tolerance=0.1; //tolerance for connectors. they will be smaller

module rackElement(h1=40, h2=40, hightBottom=10, hightMid=10, hightTop=5,
  elementWidth=60, elementWallWidth=10, elementDepth=30)
{
  allHight=h1+h2+hightBottom+hightMid+hightTop - minkowskiThick*2;
  widthAll=elementWidth+elementWallWidth;
  dephtAll=elementDepth-minkowskiThick;


  difference() {
    translate([minkowskiThick,minkowskiThick,0])
    minkowski() {
      cube([widthAll-minkowskiThick*2,allHight,dephtAll]);
      cylinder(r=minkowskiRadius,h=minkowskiThick);
    }

    /* cutout for D1 */
    translate([elementWallWidth,hightBottom,0])
      cube([widthAll-elementWallWidth,h1,dephtAll+minkowskiThick]);

    /* cutout for D2 */
    hightCutoutD2 = hightBottom + h1 + hightMid;
    translate([elementWallWidth,hightCutoutD2,0])
      cube([widthAll-elementWallWidth,h2,dephtAll+minkowskiThick]);

    /* cutout for top */
    hightCutoutTop = hightCutoutD2 + h2;
    translate([widthTop,hightCutoutTop,0])
      cube([widthAll-widthTop,hightTop,dephtAll+minkowskiThick]);


    /* cutouts for connectors front */
    xfPosConD1=widthAll/2-connectorWidth/2;
    yfPosConD1=connectorWidth/2;
    translate([xfPosConD1,yfPosConD1,elementDepth-connectorWidth])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors front */
    xfPosConD2=widthAll/2-connectorWidth/2;
    yfPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xfPosConD2,yfPosConD2,elementDepth-connectorWidth])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors back*/
    xbPosConD1=widthAll/2-connectorWidth/2;
    ybPosConD1=connectorWidth/2;
    translate([xbPosConD1,ybPosConD1,0])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors back*/
    xbPosConD2=widthAll/2-connectorWidth/2;
    ybPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xbPosConD2,ybPosConD2,0])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors side*/
    xsPosConD1=widthAll-connectorWidth;
    ysPosConD1=connectorWidth/2;
    translate([xsPosConD1,ysPosConD1,(elementDepth-connectorWidth)/2])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors side*/
    xsPosConD2=widthAll-connectorWidth;
    ysPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xsPosConD2,ysPosConD2,(elementDepth-connectorWidth)/2])
    cube([connectorWidth,connectorWidth,connectorWidth]);

  }

}

module rackCon(conLength=100)
{
  translate([tolerance/2,tolerance,0])
  cube([connectorWidth-tolerance, connectorWidth-tolerance,conLength-tolerance]);
}


module assambledRack()
{
hightD1=40+3; //lower device hight
hightD2=30+2; //upper device hight
rackElementWidth=60;

plankHightBottom=10;
plankHightMid=10;
plankHightTop=5;

wallWidth=10;
depht=30; //depth of one element
deviceWidth=220;
deviceWidthTolerance=5;
shiftX=deviceWidth + deviceWidthTolerance + wallWidth*2;   //just align rack elements to get a view


/* front elements */
translate([0,0,0])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);
translate([shiftX,0,depht]) rotate([0,180,0])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);

/* back elements */
translate([0,0,-80])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);
translate([shiftX,0,depht-80]) rotate([0,180,0])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);




/* connectors */
connectorLen1=deviceWidth/2 + deviceWidthTolerance;

translate([70-connectorWidth,connectorWidth/2,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon(connectorLen1);
translate([70-connectorWidth,(connectorWidth/2) + plankHightBottom +hightD1,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon(connectorLen1);

translate([70-connectorWidth,(connectorWidth/2),((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon(connectorLen1);
translate([70-connectorWidth,(connectorWidth/2) + plankHightBottom +hightD1,((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon(connectorLen1);

/* side connectors */
connectorLen2=80 - depht + connectorWidth*2; //set as needed. this is the space between front elements and back elements
/* left */
translate([((rackElementWidth+wallWidth)/2 - (connectorWidth/2)), connectorWidth/2, -55])
rackCon(connectorLen2);
translate([((rackElementWidth+wallWidth)/2 - (connectorWidth/2)), 10+43+connectorWidth/2, -55])
rackCon(connectorLen2);
/* rigth */
translate([207.5, connectorWidth/2, -55])
rackCon(connectorLen2);
translate([207.5, 10+43+connectorWidth/2, -55])
rackCon(connectorLen2);
}
translate([-10,0,0]) rotate([90,0,0]) assambledRack();
/* translate([2.5,-60,12]) cube([220,160,40]); */
