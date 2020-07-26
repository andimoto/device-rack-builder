$fn=50;

hightD1=40+3;
hightD2=30+2;
hightBottom=10;
hightMid=10;
hightTop=5;
widthTop=20;

width=60;
wallWidth=10;
depht=30;

minkowskiRadius=2;
minkowskiThick=2;

connectorWidth=5;

tolerance=0.1;

module rackElement(h1=hightD1,h2=hightD2)
{
  allHight=h1+h2+hightBottom+hightMid+hightTop - minkowskiThick*2;
  widthAll=width+wallWidth;
  dephtAll=depht-minkowskiThick;


  difference() {
    translate([minkowskiThick,minkowskiThick,0])
    minkowski() {
      cube([widthAll-minkowskiThick*2,allHight,dephtAll]);
      cylinder(r=minkowskiRadius,h=minkowskiThick);
    }

    /* cutout for D1 */
    translate([wallWidth,hightBottom,0])
      cube([widthAll-wallWidth,h1,dephtAll+minkowskiThick]);

    /* cutout for D2 */
    hightCutoutD2 = hightBottom + h1 + hightMid;
    translate([wallWidth,hightCutoutD2,0])
      cube([widthAll-wallWidth,h2,dephtAll+minkowskiThick]);

    /* cutout for top */
    hightCutoutTop = hightCutoutD2 + h2;
    translate([widthTop,hightCutoutTop,0])
      cube([widthAll-widthTop,hightTop,dephtAll+minkowskiThick]);


    /* cutouts for connectors front */
    xfPosConD1=widthAll/2-connectorWidth/2;
    yfPosConD1=connectorWidth/2;
    translate([xfPosConD1,yfPosConD1,depht-connectorWidth])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors front */
    xfPosConD2=widthAll/2-connectorWidth/2;
    yfPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xfPosConD2,yfPosConD2,depht-connectorWidth])
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
    translate([xsPosConD1,ysPosConD1,(depht-connectorWidth)/2])
    cube([connectorWidth,connectorWidth,connectorWidth]);

    /* cutouts for connectors side*/
    xsPosConD2=widthAll-connectorWidth;
    ysPosConD2=connectorWidth/2 + hightBottom + h1;
    translate([xsPosConD2,ysPosConD2,(depht-connectorWidth)/2])
    cube([connectorWidth,connectorWidth,connectorWidth]);


  }

}

module rackCon()
{
  translate([tolerance/2,tolerance,0]) cube([connectorWidth-tolerance, connectorWidth-tolerance,120-tolerance]);
}


module assambledRack()
{
rackElement();
translate([240,0,depht]) rotate([0,180,0]) rackElement();
translate([0,0,-80]) rackElement();
translate([240,0,depht-80]) rotate([0,180,0]) rackElement();

/* connectors */
translate([70-connectorWidth,connectorWidth/2,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon();
translate([70-connectorWidth,(connectorWidth/2) + hightBottom +hightD1,(depht+connectorWidth)/2])
rotate([0,90,0]) rackCon();

translate([70-connectorWidth,(connectorWidth/2),((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon();
translate([70-connectorWidth,(connectorWidth/2) + hightBottom +hightD1,((depht+connectorWidth)/2)-80])
rotate([0,90,0]) rackCon();
}
rotate([90,0,0]) assambledRack();
