/*

    Lib3D Extension, imported from:

    GFX - a small graphics library 
    Copyright (C) 2004  Rafael de Oliveira Jannone

    Length of vector v, result in r

    $Id: vector_length.c,v 1.1 2009-04-10 12:47:42 stefano Exp $
*/


#include <lib3d.h>

int vector_length(vector_t *v) {
    return isqrt((v->x * v->x) + (v->y * v->y) + (v->z * v->z));
}
