/*
 * lib3d.h
 *
 * Structs for standard Wizard 3d and 4d math functions
 *
 * Copyright 2002, Mark Hamilton
 *
 */

/*
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
 *
 */

/*
 * 3D homogeneous coordinate definition
 * https://en.wikipedia.org/wiki/Homogeneous_coordinates
 *
 * project 3D coords onto 2D screen
 * https://stackoverflow.com/questions/724219/how-to-convert-a-3d-point-into-2d-perspective-projection
 *
 * Goodbye Far Clipping Plane.
 * https://chaosinmotion.com/2010/09/06/goodbye-far-clipping-plane/
 *
 * 3D Clipping in Homogeneous Coordinates
 * https://chaosinmotion.com/2016/05/22/3d-clipping-in-homogeneous-coordinates/
 *
 * transformation matrix:
 * https://www.tutorialspoint.com/computer_graphics/3d_transformation.htm
 *
 */

#ifndef __LIB3D_H__
#define __LIB3D_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/compiler.h>
#include <stdint.h>
#include <stdlib.h>

// fixed point arithmetic

/// integer to fixed-point 26.6
extern long __LIB__  i2f (int v) __z88dk_fastcall;

/// fixed-point 26.6 to integer
extern int __LIB__ f2i (long v) __z88dk_fastcall;

/// fixed-point multiplication
//#define mulfx(x,y)    (f2i(i2f(x)*y))

/// fixed-point division
//#define divfx(x,y)    (f2i(i2f(x)/y))

/// fixed-point square
//#define sqrfx(x)      (f2i(i2f(x)*x))

/// fixed-point square root
//#define sqrtfx(x)     (((long)(sqrt(x)))*8)

/// weighted average (w=0.0 -> x, w=0.5->average, w=1.0 ->y)
//#define wgavgfx(x, y, w)  (mulfx(i2f(1) - w, x) + mulfx(w, y))

// Floating point arithmetic

#define MATRIX_ORDER    4           // order for 3D homogeneous coordinate graphics

#ifdef __MATH_AM9511

    #include <math.h>
    #define ELEMENT     float_t

    #define INV(x)      1/(x)
    #define SQR(x)      sqr(x)
    #define SQRT(x)     sqrt(x)

    #define COS(x)      cos(x)
    #define SIN(x)      sin(x)
    #define TAN(x)      tan(x)

#elif __MATH_MATH32

    #include <math.h>
    #define ELEMENT     float_t

    #define INV(x)      inv(x)
    #define SQR(x)      sqr(x)
    #define SQRT(x)     sqrt(x)

    #define COS(x)      cos(x)
    #define SIN(x)      sin(x)
    #define TAN(x)      tan(x)

#elif __MATH_MATH16

    #include <math.h>
    #define ELEMENT     _Float16

    #define INV(x)      invf16(x)
    #define SQR(x)      ((x)*(x))
    #define SQRT(x)     sqrtf16(x)

    #define COS(x)      cosf16(x)
    #define SIN(x)      sinf16(x)
    #define TAN(x)      tanf16(x)

#else

    #define ELEMENT     int

    #define INV(x)      1
    #define SQR(x)      ((x)*(x))
    #define SQRT(x)     isqrt(x)

    #define COS(x)      icos(x)
    #define SIN(x)      isin(x)
    #define TAN(x)      (f2i(i2f(icos(x))/isin(x)))

#endif


/****************************************************************************/
/***          Type Definitions                                            ***/
/****************************************************************************/


/// represents a vector in 4 dimensions
typedef struct Vector_s
{
    ELEMENT x;              /// x dimension
    ELEMENT y;              /// y dimension
    ELEMENT z;              /// z dimension
    ELEMENT w;              /// w dimension
} Vector_t;

#define vector_t Vector_t

/// a triangle made of 3 vertexes
typedef struct {
    vector_t* vertexes[3];  ///< 3 vertexes
} triangle_t;

/// mesh: a set of points (vectors) refered by a set of triangles
typedef struct {
    int pcount;             ///< number of points
    int tcount;             ///< number of triangles

    vector_t* points;       ///< points
    triangle_t* triangles;  ///< triangles
} mesh_t;

/// an object is a solid in a scene, with translation, rotation and the solid's mesh
typedef struct {
    mesh_t* mesh;           ///< mesh
    unsigned char rot_x;    ///< angle of rotation X-axis
    unsigned char rot_y;    ///< angle of rotation Y-axis
    unsigned char rot_z;    ///< angle of rotation Z-axis
    int trans_x;            ///< translation on X-axis
    int trans_y;            ///< translation on Y-axis
    int trans_z;            ///< translation on Z-axis
} object_t;

typedef struct {
    int x, y;
} Point_t;

typedef struct {
    int pitch, roll, yaw;
    int x, y, z;
} Cam_t;

typedef struct matrix_s // homogeneous coordinate system
{
    ELEMENT e[MATRIX_ORDER*MATRIX_ORDER];
} matrix_t;


/****************************************************************************/
/***        Function Definitions                                          ***/
/****************************************************************************/


/* protos */
extern void __LIB__ ozrotatepointx(Vector_t *v, int rot) __smallc;
extern void __LIB__ ozrotatepointy(Vector_t *v, int rot) __smallc;
extern void __LIB__ ozrotatepointz(Vector_t *v, int rot) __smallc;
extern void __LIB__ ozplotpointcam(Vector_t *v, Cam_t *c, Point_t *p) __smallc;
extern void __LIB__ ozplotpoint(Vector_t *v, Point_t *p) __smallc;
extern void __LIB__ ozcopyvector(Vector_t *dest, Vector_t *src) __smallc;
extern void __LIB__ oztranslatevector(Vector_t *v, Vector_t *offset) __smallc;


/* protos from MSX GFX lib */

/// pure length of vector v (it involves sqrt calculus, so it is expensive)
extern int __LIB__ vector_length(vector_t *v);

/// subtract vector v1 by v2, result in r
extern void __LIB__ vector_subtract (vector_t *v1, vector_t *v2, vector_t *r) __smallc;

/// normalize vector p, result in r
extern void __LIB__ vector_normalize(vector_t *p, vector_t *r) __smallc;

/// rotate vector p by the given angles, result in r
extern void __LIB__ vector_rotate(vector_t* p, int angle_x, int angle_y, int angle_z, vector_t* r) __smallc;

/// dot product of v1 by v2
extern int __LIB__ vector_dot_product (vector_t* v1, vector_t* v2) __smallc;

/// cross product of v1 by v2, result into r
extern void __LIB__ vector_cross_product (vector_t* v1, vector_t* v2, vector_t* r) __smallc;

/// cross product of the z axis of v1 by v2
extern int __LIB__ vector_cross_product_z (vector_t* v1, vector_t* v2) __smallc;

/// scale vector v by s, result in r
extern void __LIB__ vector_scalar(vector_t *v, int s, vector_t* r) __smallc;

/// add vector v1 with v2, result in r
extern void __LIB__ vector_add(vector_t *v1, vector_t *v2, vector_t *r) __smallc;

/// distance between vectors v1 and v2
extern int __LIB__ vector_distance (vector_t *v1, vector_t *v2) __smallc;

/// create a new mesh with pcount points and tcount triangles
extern mesh_t __LIB__ *mesh_new(int pcount, int tcount) __smallc;

/// deallocate mesh
extern void __LIB__ mesh_delete(mesh_t* mesh) __smallc;

/// apply perspective transformations on object obj, centering the points around x and y
extern void __LIB__ object_apply_transformations(object_t* obj, vector_t* pbuffer, int x, int y) __smallc;

/*
    Integer sin functions taken from the lib3d library, OZ7xx DK
    by Hamilton, Green and Pruss
    isin and icos return a value between -254 and +255
    (changed by Stefano, originally it was +/- 16384)
*/

extern int __LIB__  isin(unsigned int degrees) __z88dk_fastcall;    /* input must be between 0 and 360 */
extern int __LIB__  icos(unsigned int degrees) __z88dk_fastcall;    /* input must be between 0 and 360 */
extern int __LIB__  div256(long value) __z88dk_fastcall;            /* divide by 255 */


/* Monochrome graphics functions depending on lib3d portions */
/* they extend the <graphics.h> capability */

/* Draw an ellipse arc delimited by 'startangle' and 'endangle' (deg) */
extern void __LIB__ ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius) __smallc;

/* Draw an arc delimited by 'startangle' and 'endangle' (deg) */
#define arc(x,y,s,e,r)  ellipse(x,y,s,e,r,r)

/* Draw a polygon by a given number of corners, rotation in degrees determined by sa. */
extern void __LIB__ polygon(int cx, int cy, int corners, int r, int sa) __smallc;


/* As above but related to the "stencil" object */
extern void __LIB__ stencil_add_polygon(int cx, int cy, int corners, int r, int sa, unsigned char *stencil) __smallc;
extern void __LIB__ stencil_add_ellipse(int cx, int cy, int sa, int ea, int xradius, int yradius, unsigned char *stencil) __smallc;
#define stencil_add_arc(x,y,s,e,r,t)  stencil_add_ellipse(x,y,s,e,r,r,t)


/* Turtle Graphics */

#define T_NORTH 270
#define T_SOUTH 90
#define T_WEST 180
#define T_EAST 0
extern int __LIB__  set_direction(int degrees) __z88dk_fastcall; /* input must be between 0 and 360 */
extern int __LIB__  fwd(int length) __z88dk_fastcall;
extern int __LIB__  turn_left(int degrees) __z88dk_fastcall; /* input must be between 0 and 360 */
extern int __LIB__  turn_right(int degrees) __z88dk_fastcall; /* input must be between 0 and 360 */


/* Homogenous Coordinate 3D Graphics */

/* Produce a unit vector */
extern void __LIB__ unit_v(vector_t * vect) __smallc;

/* Scale a vector by m, but don't touch w dimension */
extern void __LIB__ scale_v(vector_t * vect, ELEMENT scale) __smallc;

/* Produce a dot product between vectors */
ELEMENT __LIB__ dot_v(vector_t * vect1, vector_t * vect2) __smallc;

/* Vector Matrix Multiplication [vect] = [vect]*[multiplier] */
extern void __LIB__ mult_v(vector_t * vect, matrix_t * multiplier) __smallc;

/* Produce an identity matrix */
extern void __LIB__ identity_m(matrix_t * matrix) __smallc;

/* Produce a transformation (translation) */
extern void __LIB__ translate_m(matrix_t * matrix, ELEMENT x, ELEMENT y, ELEMENT z) __smallc;

/* Produce a transformation (scale) */
extern void __LIB__ scale_m(matrix_t * matrix, ELEMENT x, ELEMENT y, ELEMENT z) __smallc;

/* Produce a transformation (shear) */
extern void __LIB__ shear_m(matrix_t * matrix, ELEMENT x, ELEMENT y, ELEMENT z) __smallc;

/* Rotation in x dimension */
extern void __LIB__ rotx_m(matrix_t * matrix, ELEMENT angle) __smallc;

/* Rotation in y dimension */
extern void __LIB__ roty_m(matrix_t * matrix, ELEMENT angle) __smallc;

/* Rotation in z dimension */
extern void __LIB__ rotz_m(matrix_t * matrix, ELEMENT angle) __smallc;

/* Set up projection OpenGL */
extern void __LIB__ projection_opengl_m(matrix_t * matrix, ELEMENT fov, ELEMENT aspect_ratio, ELEMENT near, ELEMENT far) __smallc;

/* Set up projection W3Woody */
extern void __LIB__ projection_w3woody_m(matrix_t * matrix, ELEMENT fov, ELEMENT aspect_ratio, ELEMENT near, ELEMENT far) __smallc;

/* Matrix Multiplication [multiplicand] = [multiplicand]*[multiplier] */
extern void __LIB__ mult_m(matrix_t * multiplicand, matrix_t * multiplier) __smallc;


#ifdef __cplusplus
}
#endif

#endif /* __LIB3D_H__ */
