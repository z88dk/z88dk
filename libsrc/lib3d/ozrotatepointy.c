/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include <lib3d.h>

void ozrotatepointy(Vector_t *v, int rot)
{
    static long x, z;
	x = v->x;
	z = v->z;
    v->x = div256(x * icos(rot) - z * isin(rot));
    v->z = div256(x * isin(rot) + z * icos(rot));
}
