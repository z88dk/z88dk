/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include "lib3d.h"

ozrotatepointx(Vector_t *_v, int rot)
{
    static long y, z;
    register Vector_t *v=_v;
	y = v->y;
	z = v->z;
    v->y = div16384(y * icos(rot) - z * isin(rot));
    v->z = div16384(y * isin(rot) + z * icos(rot));
}
