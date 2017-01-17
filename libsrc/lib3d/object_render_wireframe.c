/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Render an object with wireframes
	
	$Id: object_render_wireframe.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>
#include <msx.h>
//#include <string.h>

void object_render_wireframe(surface_t* s, object_t* obj, vector_t* pbuffer) {
	int c, diff;
	vector_t *i, *j, *k, q1, q2;
	mesh_t* mesh = obj->mesh;
	vector_t* m = mesh->points;
	triangle_t* t = mesh->triangles;

	object_apply_transformations(obj, pbuffer, 128, 96); // FIXME: must use surface center

	m = mesh->points;
	diff = (char*)pbuffer - (char*)m;
	for (c = 0; c < mesh->tcount; c++) {
		i = (vector_t*)((char*)t->vertexes[0] + diff);
		j = (vector_t*)((char*)t->vertexes[1] + diff);
		k = (vector_t*)((char*)t->vertexes[2] + diff);

		vector_subtract(j, i, &q1);
		vector_subtract(k, i, &q2);
		
		if (vector_cross_product_z(&q1, &q2) > 0) {
			surface_line(s, i->x, i->y, j->x, j->y);
			surface_line(s, j->x, j->y, k->x, k->y);
			surface_line(s, k->x, k->y, i->x, i->y);
		}
		t++;
	}	
}
