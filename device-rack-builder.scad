/* device-rack-builder.scad
Author: andimoto@posteo.de
----------------------------
for placing assambled parts and
single parts go to end of this file!
 */

$fn=50;


/* modules */

widthTop=20; //this is the rest width of the upper plank; set as you wish
connectorWidth=5;
tolerance=0.1; //tolerance for connectors. they will be smaller

module rackElement(h1=40, h2=40, hightBottom=10, hightMid=10, hightTop=5,
  elementWidth=60, elementWallWidth=10, elementDepth=30)
{
  minkowskiRadius=2;
  minkowskiThick=2;

  allHight=h1+h2+hightBottom+hightMid+hightTop - minkowskiThick*2;
  widthAll=elementWidth+elementWallWidth;
  dephtAll=elementDepth-minkowskiThick;


  difference() {
    translate([minkowskiThick,minkowskiThick,0])
    minkowski() {
      cube([widthAll-minkowskiThick*2,allHight,dephtAll]);
      cylinder(r=minkowskiRadius,h=minkowskiThick);
    }
    extra=tolerance*2; //this is just to see the model with no need to render
    /* cutout for D1 */
    translate([elementWallWidth,hightBottom,-extra/2])
      cube([widthAll-elementWallWidth+extra,h1,dephtAll+minkowskiThick+extra]);

    /* cutout for D2 */
    hightCutoutD2 = hightBottom + h1 + hightMid;
    translate([elementWallWidth,hightCutoutD2,-extra/2])
      cube([widthAll-elementWallWidth+extra,h2,dephtAll+minkowskiThick+extra]);

    /* cutout for top */
    hightCutoutTop = hightCutoutD2 + h2;
    translate([widthTop,hightCutoutTop-extra/2,-extra/2])
      cube([widthAll-widthTop+extra,hightTop+extra,dephtAll+minkowskiThick+extra]);


    /* cutouts for connectors front */
    xfPosConD1=widthAll/2-connectorWidth/2;
    yfPosConD1=connectorWidth/2;
    translate([xfPosConD1,yfPosConD1,elementDepth-connectorWidth])
    cube([connectorWidth,connectorWidth,connectorWidth+extra]);

    /* cutouts for connectors front */
    xfPosConD2=widthAll/2-connectorWidth/2;
    yfPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xfPosConD2,yfPosConD2,elementDepth-connectorWidth])
    cube([connectorWidth,connectorWidth,connectorWidth+extra]);

    /* cutouts for connectors back*/
    xbPosConD1=widthAll/2-connectorWidth/2;
    ybPosConD1=connectorWidth/2;
    translate([xbPosConD1,ybPosConD1,-extra])
    cube([connectorWidth,connectorWidth,connectorWidth+extra]);

    /* cutouts for connectors back*/
    xbPosConD2=widthAll/2-connectorWidth/2;
    ybPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xbPosConD2,ybPosConD2,-extra])
    cube([connectorWidth,connectorWidth,connectorWidth+extra]);

    /* cutouts for connectors side*/
    xsPosConD1=widthAll-connectorWidth;
    ysPosConD1=connectorWidth/2;
    translate([xsPosConD1,ysPosConD1,(elementDepth-connectorWidth)/2])
    cube([connectorWidth+extra,connectorWidth,connectorWidth]);

    /* cutouts for connectors side*/
    xsPosConD2=widthAll-connectorWidth;
    ysPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xsPosConD2,ysPosConD2,(elementDepth-connectorWidth)/2])
    cube([connectorWidth+extra,connectorWidth,connectorWidth]);

  }

}

module rackCon(conLength=100)
{
  translate([tolerance/2,tolerance,0])
  cube([connectorWidth-tolerance, connectorWidth-tolerance,conLength-tolerance]);
}



/* ------------------------------------------- */
/* -----------PARAMETERS & PLACING------------ */
/* ------------------------------------------- */
hightD1=40+3; //lower device hight
hightD2=30+2; //upper device hight
rackElementWidth=60; //complete width of one rack element

plankHightBottom=10; //hight of the bottom plank
plankHightMid=10; //hight of the middle plank
plankHightTop=5; //hight of the upper plank

wallWidth=10; //outer wall width
depht=30; //depth of one element

deviceWidth=220;
deviceWidthTolerance=5;
/* connectors */
/* distance between to rackElement in width direction */
connectorLen1=deviceWidth/2 + deviceWidthTolerance;
/* side connectors */
/* distance between to rackElements in direction of depth */
connectorLen2=50 + connectorWidth*2;


module assambledRack()
{

//just align rack elements to get a view
shiftX=deviceWidth + deviceWidthTolerance + wallWidth*2;


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
translate([70-connectorWidth,connectorWidth/2,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon(connectorLen1);
translate([70-connectorWidth,(connectorWidth/2) + plankHightBottom +hightD1,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon(connectorLen1);

/* side connectors */
translate([70-connectorWidth,(connectorWidth/2),((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon(connectorLen1);
translate([70-connectorWidth,(connectorWidth/2) + plankHightBottom +hightD1,((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon(connectorLen1);


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

module allPartsPrintableOn20()
{
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);

translate([85,90,0]) rotate([0,0,180])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);

translate([90,0,0])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);

translate([175,90,0]) rotate([0,0,180])
rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth);

translate([0,105,0])
rotate([0,90,0]) rackCon(connectorLen1);

translate([0,115,0])
rotate([0,90,0]) rackCon(connectorLen1);

translate([0,125,0])
rotate([0,90,0]) rackCon(connectorLen1);

translate([0,135,0])
rotate([0,90,0]) rackCon(connectorLen1);

translate([0,145,0])
rotate([0,90,0]) rackCon(connectorLen2);

translate([connectorLen2+5,145,0])
rotate([0,90,0]) rackCon(connectorLen2);

translate([0,155,0])
rotate([0,90,0]) rackCon(connectorLen2);

translate([connectorLen2+5,155,0])
rotate([0,90,0]) rackCon(connectorLen2);

}
//uncomment this to place all parts for printing on 20cm x 20cm
allPartsPrintableOn20();

//uncomment this to place assambled rack
/* translate([-10,-150,0]) rotate([90,0,0]) assambledRack(); */

/* uncomment this to place a dummy router into rack */
/* translate([2.5,-200,12]) color("red") cube([220,160,40]); */


/* single parts: uncomment one of these to save them as stl/3mf */
/* rackCon(connectorLen1); */
/* rackCon(connectorLen2); */

/* rackElement(h1=hightD1,h2=hightD2,
  hightBottom=plankHightBottom, hightMid=plankHightMid, hightTop=plankHightTop,
  elementWidth=rackElementWidth, elementWallWidth=wallWidth); */
