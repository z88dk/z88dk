/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Create new mesh
	
	$Id: mesh_delete.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>
#include <malloc.h>

void mesh_delete(mesh_t* mesh) {
	free(mesh->points);
	free(mesh->triangles);
	free(mesh);
}


