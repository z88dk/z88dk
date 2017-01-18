/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	add vector v1 with v2, result in r
	
	$Id: vector_add.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>


void vector_add(vector_t *v1, vector_t *v2, vector_t *r) {
	r->x = v1->x + v2->x;
	r->y = v1->y + v2->y;
	r->z = v1->z + v2->z;
}
