/*

	Graphics functions requiring some of the LIB3D Extensions
	* stencil version

	stencil_add_ellipse( cx,  cy,  startangle,  endangle,  xradius,  yradius, stencil)
	
	Draw an ellipse arc delimited by 'startangle' and 'endangle',
	specified in degrees.
	
	
	$Id: stencil_add_ellipse.c,v 1.2 2013-10-09 06:10:34 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


void stencil_add_ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius, unsigned char *stencil)
{
int i,k;

	k=sa;
	stencil_add_point(cx+icos(sa)*xradius/256,cy+isin(sa)*yradius/256,stencil);

	if (ea==0) k=360; else k=ea;

	for (i=sa;i!=k;i++) {
		if (i==360) i=0;
		stencil_add_lineto(cx+icos(i)*xradius/256,cy+isin(i)*yradius/256,stencil);
	}
}

