/*

	Lib3D Extension, imported from:

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Render an object with flat-shading, requires a normalized source of light
	
	$Id: object_render_flatshading.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>
#include <msx.h>
#include <graphics.h>
#include <string.h>

void object_render_flatshading(surface_t* s, object_t* obj, vector_t* pbuffer, char* stencil, vector_t* light) {
	int c, diff;
	//int l, top, bottom;
	vector_t *i, *j, *k;
	vector_t q1, q2, N;
	mesh_t* mesh = obj->mesh;
	vector_t* m = mesh->points;
	triangle_t* t = mesh->triangles;
	int li;

	object_apply_transformations(obj, pbuffer, 128, 96); // FIXME: must use surface center

	m = mesh->points;
	diff = (char*)pbuffer - (char*)m;
	for (c = 0; c < mesh->tcount; c++) {
		i = (vector_t*)((char*)t->vertexes[0] + diff);
		j = (vector_t*)((char*)t->vertexes[1] + diff);
		k = (vector_t*)((char*)t->vertexes[2] + diff);

		vector_subtract(j, i, &q1);
		vector_subtract(k, i, &q2);
		vector_cross_product(&q1, &q2, &N);

		if (N.z > 0) {
			vector_normalize(&N, &N);
			//li = vector_dot_product(&N, light)*5;
			//li = f2i(li);
			//li = (li < 0) ? 0 : ((li > 4) ? 4 : li);

			// FIXME: can optimize memset's by covering only "top" to "bottom" lines
			// in this case we should require clean buffers to start with.
			// and we should clean them after rendering.
			//memset(low, MODE2_HEIGHT << 1, 64);	// FIXME: must use surface height
			//memset(high, MODE2_HEIGHT << 1, 0);	// FIXME: must use surface height
			stencil_init(stencil);

			// calculate polygon
			stencil_add_side(i->x, i->y, j->x, j->y, stencil);
			stencil_add_side(j->x, j->y, k->x, k->y, stencil);
			stencil_add_side(k->x, k->y, i->x, i->y, stencil);


/*
			top = (i->y < j->y) ? ((i->y < k->y) ? i->y : k->y) : ((j->y < k->y) ? j->y : k->y);
			bottom = (i->y > j->y) ? ((i->y > k->y) ? i->y : k->y) : ((j->y > k->y) ? j->y : k->y);

			for (l = top; l <= bottom; l++) {
				surface_hline(s, low[l], l, high[l], DITHER(li, l));
			}
*/
			surface_stencil_render(s, stencil, vector_dot_product(&N, light)/6);
			//surface_stencil_render(s, stencil, li);
		}
		t++;
	}	
}

