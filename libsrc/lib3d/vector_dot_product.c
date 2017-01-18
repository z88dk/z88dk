/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Dot product of v1 by v2
	
	$Id: vector_dot_product.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>


int vector_dot_product (vector_t* v1, vector_t* v2) {
	//return (v1->x * v2->x + v1->y * v2->y + v1->z * v2->z);
	return mulfx(v1->x, v2->x) + mulfx(v1->y, v2->y) + mulfx(v1->z, v2->z);
}
