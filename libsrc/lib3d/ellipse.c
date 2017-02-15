/*

	Graphics functions requiring some of the LIB3D Extensions

	ellipse( cx,  cy,  startangle,  endangle,  xradius,  yradius)
	
	Draw an ellipse arc delimited by 'startangle' and 'endangle',
	specified in degrees.
	
	
	$Id: ellipse.c,v 1.3 2013-10-09 06:10:33 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


void ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius)
{

int i,k;

	plot(cx+icos(sa)*xradius/256,cy+isin(sa)*yradius/256);
	
	if (ea==0) k=360; else k=ea;

	for (i=sa;i!=k;i++) {
		if (i==360) i=0;
		drawto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256);
	}
}
