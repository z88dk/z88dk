/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#include <lib3d.h>
#include <string.h>

void ozcopyvector(Vector_t *dest, Vector_t *src)
{
    memcpy(dest,src,sizeof(Vector_t));
}
