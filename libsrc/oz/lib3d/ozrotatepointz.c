/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include "lib3d.h"

ozrotatepointz(Vector_t *_v, int rot)
{
    static long x, y;
    register Vector_t *v=_v;
	x = v->x;
	y = v->y;
    v->x = div16384(x * icos(rot) - y * isin(rot));
    v->y = div16384(x * isin(rot) + y * icos(rot));
}
