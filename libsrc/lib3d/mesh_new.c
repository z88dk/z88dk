/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Create new mesh
	
	$Id: mesh_new.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>
#include <malloc.h>


/// allocates space for  c elements of type x
#define newa(x, c)	((x*)malloc(sizeof(x) * c))


mesh_t* mesh_new(int pcount, int tcount) {
	//mesh_t* r = new(mesh_t);
	mesh_t* r;
	
	r = (mesh_t*)malloc(sizeof(mesh_t));
	r->pcount = pcount;
	r->tcount = tcount;
	r->points = newa(vector_t, pcount);
	r->triangles = newa(triangle_t, tcount);
	return r;
}

