/*

	Graphics functions requiring some of the LIB3D Extensions
	* stencil version

	stencil_add_polygon(cx, cy, corners, radius, startangle,stencil)
	
	Add a regular polygon of a given no. of corners and a corner at a given angle (0..360).
	
	
	$Id: stencil_add_polygon.c,v 1.1 2013-05-15 06:45:47 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


void stencil_add_polygon(int cx, int cy, int corners, int r, int sa, unsigned char *stencil)
{

int i,k;

	k=sa;
	stencil_add_point(cx+icos(k)*r/256,cy+isin(k)*r/256,stencil);

	for (i=0;i++<corners;k=(k+360/corners)%360)
		stencil_add_lineto(cx+icos(k)*r/256,cy+isin(k)*r/256,stencil);

	stencil_add_lineto(cx+icos(sa)*r/256,cy+isin(sa)*r/256,stencil);
}

