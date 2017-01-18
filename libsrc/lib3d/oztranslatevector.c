/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include "lib3d.h"

void oztranslatevector(Vector_t *v, Vector_t *offset)
{
	v->x += offset->x;
	v->y += offset->y;
	v->z += offset->z;
}
