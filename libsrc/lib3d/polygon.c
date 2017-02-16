/*

	Graphics functions requiring some of the LIB3D Extensions

	polygon(cx, cy, corners, radius, startangle)
	
	Draw a polygon of a given no. of corners and a corner at a given angle (0..360).
	
	
	$Id: polygon.c,v 1.1 2013-05-08 16:41:36 stefano Exp $
*/


#include <graphics.h> 
#include <lib3d.h> 


void polygon(int cx, int cy, int corners, int r, int sa)
{

int i,k;

	k=sa;
	plot(cx+icos(k)*r/256,cy+isin(k)*r/256);

	for (i=0;i++<corners;k=(k+360/corners)%360)
		drawto(cx+icos(k)*r/256,cy+isin(k)*r/256);

	drawto(cx+icos(sa)*r/256,cy+isin(sa)*r/256);
}

