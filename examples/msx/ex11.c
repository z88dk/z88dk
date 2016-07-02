/*=========================================================================

GFX EXAMPLE CODE - #10
	"spinning solid"

Copyright (C) 2004  Rafael de Oliveira Jannone

This example's source code is Public Domain.

WARNING: The author makes no guarantees and holds no responsibility for 
any damage, injury or loss that may result from the use of this source 
code. USE IT AT YOUR OWN RISK.

Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284

=========================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "lib3d.h"
#include "msx/line.h"

// build a pyramid mesh

#define HPSIZE 3000
	HEAPSIZE(HPSIZE)


	u_char* sbuffer[MODE2_MAX];
	unsigned char stencil[MODE2_HEIGHT*2];


mesh_t* build_mesh() {
	int p;
	double c;
	mesh_t* mesh = mesh_new(5, 6);	// 5 vertexes, 6 triangles
	vector_t* points = mesh->points;
	triangle_t* triangles = mesh->triangles;

	double FULL_CIRCLE = 8.0 * atan(1.0);

	// define the base points
	for (p = 0; p < 4; p++) {
		c = FULL_CIRCLE * p / 4.0;
		points[p].x = (int)(10.0 * cos(c) * 64.0);
		points[p].y = (int)(10.0 * sin(c) * 64.0);
		points[p].z = i2f(5);
	}
	// define the top point
	points[4].x = 0;
	points[4].y = 0;
	points[4].z = i2f(-5);

	// define triangles
	// side a
	triangles[0].vertexes[0] = &points[4];
	triangles[0].vertexes[1] = &points[0];
	triangles[0].vertexes[2] = &points[1];

	// side b
	triangles[1].vertexes[0] = &points[4];
	triangles[1].vertexes[1] = &points[1];
	triangles[1].vertexes[2] = &points[2];

	// side c
	triangles[2].vertexes[0] = &points[4];
	triangles[2].vertexes[1] = &points[2];
	triangles[2].vertexes[2] = &points[3];

	// side d
	triangles[3].vertexes[0] = &points[4];
	triangles[3].vertexes[1] = &points[3];
	triangles[3].vertexes[2] = &points[0];

	// base 1
	triangles[4].vertexes[0] = &points[0];
	triangles[4].vertexes[1] = &points[3];
	triangles[4].vertexes[2] = &points[2];

	// base 2
	triangles[5].vertexes[0] = &points[2];
	triangles[5].vertexes[1] = &points[1];
	triangles[5].vertexes[2] = &points[0];

	return mesh;	// done! :)
}

main() {
	bool flat = false;
	//int *low, *high;
	vector_t light;

	surface_t screen;

	// this is a vector buffer, for the transformations
	// our only object have 5 vertexes, but we'll make space for 32 anyway
	vector_t *pbuffer;

	// off-screen surface buffer
	//u_char* sbuffer = (u_char*)malloc(MODE2_MAX);

	// our solid :)
	object_t triangle;


	heapinit (HPSIZE);
	
	pbuffer = newa(vector_t, 32);

	triangle.mesh = build_mesh();
	triangle.rot_x = triangle.rot_y = triangle.rot_z = 0;
	triangle.trans_x = triangle.trans_y = 0;
	triangle.trans_z = i2f(30);	// remember: we are using fixed-point numbers

	screen.data.ram = sbuffer;

	// polygon rendering buffers
	//low = newa(int, MODE2_HEIGHT);
	//high = newa(int, MODE2_HEIGHT);

	// light source
	light.x = light.y = light.z = i2f(1);
	vector_normalize(&light, &light);

	printf("spinning solid demo\n\n");

	printf("instructions:\n   press [UP] to toggle flat shading\n\n");

	printf("creating look-up tables, please wait\n");
	create_lookup_tables();

	// set screen to graphic mode
	set_color(15, 1, 1);
	set_mode(mode_2);
	fill(MODE2_ATTR, 0xF1, MODE2_MAX);

	//surface_line(&screen, 0, 0, 0, 0); // FIXME: won't compile without this crap

	while (!get_trigger(0)) {
		if (get_stick(0) == 1)
			flat = !flat;

		// rotate a bit
		triangle.rot_y += 2;
		triangle.rot_x += 3;
		triangle.rot_z += 1;

		// clear the off-screen buffer
		memset(sbuffer, 0, MODE2_MAX);	// [*] 

	//surface_line(screen, 0, 0, 10, 10);

		// render the object
		if (flat)
			//object_render_flatshading(&screen, &triangle, pbuffer, low, high, &light);
			object_render_flatshading(&screen, &triangle, pbuffer, stencil, &light);
		else
			object_render_wireframe(&screen, &triangle, pbuffer);

		// show the off-screen buffer
		//vwrite(screen.data.ram, 0, MODE2_MAX); // [*]
		msx_vwrite_direct(screen.data.ram, 0, MODE2_MAX);

		// [*] FIXME: there will be better ways of doing this (soon)
	}

	// go back to text mode
	set_mode(mode_0);

	// deallocate stuff

	mesh_delete(triangle.mesh);
	//free(sbuffer);
	//free(low);
	//free(high);
	//destroy_lookup_tables();
}
