/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	/// scale vector v by s, result in r
	
	$Id: vector_scalar.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

void vector_scalar(vector_t *v, int s, vector_t* r) {
	r->x = mulfx(v->x, s);
	r->y = mulfx(v->y, s);
	r->z = mulfx(v->z, s);
}
