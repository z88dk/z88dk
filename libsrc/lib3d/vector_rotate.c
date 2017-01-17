/*

	Lib3D Extension, based on the OZ DK and:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Rotate vector p by the given angles, result in r
	
	$Id: vector_rotate.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

void vector_rotate(vector_t* p, int angle_x, int angle_y, int angle_z, vector_t* r) {

ozcopyvector (r,p);
ozrotatepointz (r,angle_z);
ozrotatepointy (r,angle_y);
ozrotatepointx (r,angle_x);

}
