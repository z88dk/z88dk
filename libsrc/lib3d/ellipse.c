/*

	Graphics functions requiring some of the LIB3D Extensions

	ellipse( cx,  cy,  startangle,  endangle,  xradius,  yradius)
	
	Draw an ellipse arc delimited by 'startangle' and 'endangle',
	specified in degrees.
	
	
	$Id: ellipse.c,v 1.2 2013-09-30 15:10:35 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


int ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius)
{

int i,k;

	k=sa;
	plot(cx+icos(k)*xradius/256,cy+isin(k)*yradius/256);

	for (i=sa;i++<ea;k++)
		drawto(cx+icos(k)*xradius/256,cy+isin(k)*yradius/256);

	//drawto(cx+icos(sa)*xradius/256,cy+isin(sa)*yradius/256);
}
