/*
lib3d.c

Standard Wizard 3d and 4d math functions

Copyright 2002, Mark Hamilton

*/

#include <lib3d.h>
#include <string.h>

void ozcopyvector(vector_t *dest, vector_t *src)
{
    memcpy(dest,src,sizeof(vector_t));
}
