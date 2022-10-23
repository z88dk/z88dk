/*
 * mult_m.c
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
#include <string.h>
#include <math.h>

#include <lib3d.h>


/****************************************************************************/
/***       Function                                                       ***/
/****************************************************************************/


/* Matrix Multiplication */
void mult_m(matrix_t * multiplicand, matrix_t * multiplier)
{
    matrix_t result;

    memset(&result, 0, sizeof(ELEMENT)*MATRIX_ORDER*MATRIX_ORDER);

    for(uint8_t y = 0; y < MATRIX_ORDER; ++y) {
        uint8_t col = y * MATRIX_ORDER;
        for(uint8_t x = 0; x < MATRIX_ORDER; ++x) {
            for(uint8_t i = 0; i < MATRIX_ORDER; ++i) {
                result.e[col + x] += multiplicand->e[col + i] * multiplier->e[i * MATRIX_ORDER + x];
            }
        }
    }

    *multiplicand = result;
}
