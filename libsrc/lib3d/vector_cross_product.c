/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Cross product of v1 by v2, result into r
	
	$Id: vector_cross_product.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

void vector_cross_product (vector_t* v1, vector_t* v2, vector_t* r) {
	int x, y, z;
	x = mulfx(v1->y, v2->z) - mulfx(v1->z, v2->y);
	y = mulfx(v1->z, v2->x) - mulfx(v1->x, v2->z);
	z = mulfx(v1->x, v2->y) - mulfx(v1->y, v2->x);
	//x = (v1->y * v2->z) - (v1->z * v2->y);
	//y = (v1->z * v2->x) - (v1->x * v2->z);
	//z = (v1->x * v2->y) - (v1->y * v2->x);
	r->x = x; r->y = y; r->z = z;
}

