/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include <lib3d.h>

void ozrotatepointz(Vector_t *v, int rot)
{
    static long x, y;
	x = v->x;
	y = v->y;
    v->x = div256(x * icos(rot) - y * isin(rot));
    v->y = div256(x * isin(rot) + y * icos(rot));
}
