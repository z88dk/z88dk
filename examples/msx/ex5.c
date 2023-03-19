/*=========================================================================

GFX EXAMPLE CODE - #5
	"the evil eye, line drawing"

Copyright (C) 2004  Rafael de Oliveira Jannone

This example's source code is Public Domain.

WARNING: The author makes no guarantees and holds no responsibility for 
any damage, injury or loss that may result from the use of this source 
code. USE IT AT YOUR OWN RISK.

Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284

=========================================================================
	
Z88DK Version.
Compile with:   zcc +msx -lm -startup=2 ex5.c

=========================================================================*/

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <video/tms99x8.h>

typedef struct {
	int x;
	int y;
} point_t;

#define MAX_POINT	12

uint8_t buf[MODE2_MAX];
//uint8_t* buf;

void main() {
	
	//buf = (uint8_t*)malloc(MODE2_MAX);

	double	m_pi;
	double	a;
	int	c, i;
	surface_t surf;
	point_t	p[MAX_POINT];

	printf("calculating, wait...\n");

	m_pi = 8.0 * atan(1.0);

	// calculates points from circunference
	for (c = 0; c < MAX_POINT; c++) {
		a = (m_pi * (double)c) / (double)MAX_POINT;
		p[c].x = (int)(100.0 * cos(a) + 128.0);
		p[c].y = (int)(80.0 * sin(a) + 96.0);
	}

	// clear the off-screen surface
	printf("clearing buffer...\n");
	memset(buf, 0, MODE2_MAX);

	printf("drawing...\n");
	surf.data.ram = buf;

	// draw the eye's lines into the surface (obs: we are NOT in graphic mode yet)
	for (c = 0; c < MAX_POINT; c++) 
		for (i = c+1; i < MAX_POINT; i++)
			surface_draw(&surf, p[c].x, p[c].y, p[i].x, p[i].y);

	surface_circle(&surf, 128, 96, 50, 1);

	// set screen to graphic mode
	vdp_color(15, 1, 1);
	vdp_set_mode(mode_2);
	vdp_vfill(MODE2_ATTR, 0xF1, MODE2_MAX);

	// finally show the surface
	vdp_vwrite_direct(surf.data.ram, 0, MODE2_MAX);

	while (!getk()) {}

	vdp_set_mode(mode_0);
}
