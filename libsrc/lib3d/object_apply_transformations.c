/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Apply perspective transformations on object obj, centering the points around x and y
	
	$Id: object_apply_transformations.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

void object_apply_transformations(object_t* obj, vector_t* pbuffer, int x, int y) {
	mesh_t* mesh = obj->mesh;
	vector_t* m = mesh->points;
	int c = mesh->pcount;
	while (c--) {
		vector_rotate(m, obj->rot_x, obj->rot_y, obj->rot_z, pbuffer);
		pbuffer->z += obj->trans_z;
		pbuffer->z /= 128;
		pbuffer->x = ((pbuffer->x + obj->trans_x) / pbuffer->z) + x;
		pbuffer->y = ((pbuffer->y + obj->trans_y) / pbuffer->z) + y;
		++pbuffer;
		++m;
	}
}
