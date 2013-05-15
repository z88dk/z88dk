/*

	Graphics functions requiring some of the LIB3D Extensions
	* stencil version

	stencil_add_ellipse( cx,  cy,  startangle,  endangle,  xradius,  yradius, stencil)
	
	Draw an ellipse arc delimited by 'startangle' and 'endangle',
	specified in degrees.
	
	
	$Id: stencil_add_ellipse.c,v 1.1 2013-05-15 06:45:46 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


int stencil_add_ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius, unsigned char *stencil)
{

int i;

	stencil_add_point(cx+icos(sa)*xradius/256,cy+isin(sa)*yradius/256,stencil);

	for (i=sa;i!=ea;i++) {
		if (i==360)  i=0;
		stencil_add_lineto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256,stencil);
	}
	stencil_add_lineto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256,stencil);
}

