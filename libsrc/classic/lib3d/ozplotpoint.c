/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright 2002, Mark Hamilton

*/

#include <lib3d.h>

void ozplotpoint(vector_t *v, point_t *p)
{
    vector_t temp;

    /* flip x and y to rotate points 90 deg */
    temp.x = v->y;
    temp.y = v->x;
    temp.z = v->z + 256; /* add a large number so it doesn't look too big */
    /* add perspective */
    p->x = temp.x * 256 / temp.z;
    p->y = temp.y * 256 / temp.z;
}
