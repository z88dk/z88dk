/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	distance between vectors v1 and v2
	
	$Id: vector_distance.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

int vector_distance (vector_t *v1, vector_t *v2) {
	vector_t r;
	vector_subtract(v1, v2, &r);
	return vector_length(&r);
}
