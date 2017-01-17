/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Normalize vector p, result in r
	
	$Id: vector_normalize.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

void vector_normalize(vector_t *p, vector_t *r) {
	int d = vector_length(p);
	if (d != 0) {
		//r->x = p->x / d;
		//r->y = p->y / d;
		//r->z = p->z / d;
		r->x = divfx(p->x, d);
		r->y = divfx(p->y, d);
		r->z = divfx(p->z, d);
	}
}
