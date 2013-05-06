/*

	Graphics functions requiring some of the LIB3D Extensions

	ellipse( cx,  cy,  startangle,  endangle,  xradius,  yradius)
	
	Draw an ellipse arc delimited by 'startangle' and 'endangle',
	specified in degrees.
	
	
	$Id: ellipse.c,v 1.1 2013-05-06 10:39:17 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


int ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius)
{

int i;

	plot(cx+icos(sa)*xradius/256,cy+isin(sa)*yradius/256);

	for (i=sa;i!=ea;i++) {
		if (i==360)  i=0;
		drawto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256);
	}
	drawto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256);
}

