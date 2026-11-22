/*
 * mult_v.c
 *
 * Copyright (c) 2022 Phillip Stevens
 * Create Time: October 2022
 *
 * The MIT License (MIT)
 *
 * Permission is hereby granted,free of charge,to any person obtaining a copy
 * of this software and associated documentation files (the "Software"),to deal
 * in the Software without restriction,including without limitation the rights
 * to use,copy,modify,merge,publish,distribute,sublicense,and/or sell
 * copies of the Software,and to permit persons to whom the Software is
 * furnished to do so,subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR
 * IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER
 * LIABILITY,WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE,ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/*
 * 3D homogeneous coordinate definition
 * https://en.wikipedia.org/wiki/Homogeneous_coordinates
 *
 * project 3D coords onto 2D screen:
 * https://stackoverflow.com/questions/724219/how-to-convert-a-3d-point-into-2d-perspective-projection
 *
 * transformation matrix:
 * https://www.tutorialspoint.com/computer_graphics/3d_transformation.htm
 *
 */

/****************************************************************************/
/***        Include files                                                 ***/
/****************************************************************************/

#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#include <lib3d.h>


/****************************************************************************/
/***       Function                                                       ***/
/****************************************************************************/


/* Vector Matrix Multiplication */
void mult_v(vector_t * vect, matrix_t * multiplier)
{
    vector_t result;

    result.x = vect->x*multiplier->e[0] + vect->y*multiplier->e[4] + vect->z*multiplier->e[8 ] + vect->w*multiplier->e[12];
    result.y = vect->x*multiplier->e[1] + vect->y*multiplier->e[5] + vect->z*multiplier->e[9 ] + vect->w*multiplier->e[13];
    result.z = vect->x*multiplier->e[2] + vect->y*multiplier->e[6] + vect->z*multiplier->e[10] + vect->w*multiplier->e[14];
    result.w = vect->x*multiplier->e[3] + vect->y*multiplier->e[7] + vect->z*multiplier->e[11] + vect->w*multiplier->e[15];

    *vect = result;
}
