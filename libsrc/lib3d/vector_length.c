/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Create new mesh
	
	$Id: vector_length.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>
#include <math.h>

int vector_length(vector_t *v) {
	return sqrtfx(sqrfx(v->x) + sqrfx(v->y) + sqrfx(v->z));
}
