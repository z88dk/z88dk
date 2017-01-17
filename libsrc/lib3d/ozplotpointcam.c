/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include "lib3d.h"

void ozplotpointcam(Vector_t *v, Cam_t *c, Point_t *p)
{
    static Vector_t temp;
    static Vector_t offset;
	temp.x = v->y;
	temp.y = v->x;
	temp.z = v->z + 256;
	offset.x = -c->x;
	offset.y = -c->y;
	offset.z = -c->z;
	ozrotatepointx(&temp, -c->pitch);
	ozrotatepointy(&temp, -c->roll);
	ozrotatepointz(&temp, -c->yaw);
	oztranslatevector(&temp, &offset);
	oztranslatevector(&temp, &offset);
	oztranslatevector(&temp, &offset);
	p->x = temp.x * 256 / temp.z;
	p->y = temp.y * 256 / temp.z;
}


