/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include <lib3d.h>

void ozrotatepointx(Vector_t *v, int rot)
{
    static long y, z;
	y = v->y;
	z = v->z;
    v->y = div256(y * icos(rot) - z * isin(rot));
    v->z = div256(y * isin(rot) + z * icos(rot));
}
