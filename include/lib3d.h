/*
lib3d.h

Structs for standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/

#ifndef __LIB3D_H__
#define __LIB3D_H__

#include <sys/compiler.h>


// fixed point arithmetic

/// integer to fixed-point
extern long __LIB__  i2f (int v) __z88dk_fastcall;

/// fixed-point to integer
extern int __LIB__ f2i (long v);

/// fixed-point multiplication
#define mulfx(x,y)	f2i((long)y * (long)x)

/// fixed-point division
#define divfx(x,y)	(i2f(x)/(long)y)

/// fixed-point square
#define sqrfx(x)	(f2i((long)x * (long)x))

/// fixed-point square root
#define sqrtfx(x)	(((long)(sqrt(x)))*8)

/// weighted average (w=0.0 -> x, w=0.5->average, w=1.0 ->y)
//#define wgavgfx(x, y, w)	(mulfx(i2f(1) - w, x) + mulfx(w, y))


#define PI   3.141592

/// represents a vector in 3 dimensions
typedef struct {
	int x, y, z;
} Vector_t;

#define vector_t Vector_t

/// a triangle made of 3 vertexes
typedef struct {
	vector_t* vertexes[3];	///< 3 vertexes
} triangle_t;

/// mesh: a set of points (vectors) refered by a set of triangles
typedef struct {
	int pcount;	///< number of points
	int tcount;	///< number of triangles

	vector_t* points;	///< points
	triangle_t* triangles;	///< triangles
} mesh_t;

/// an object is a solid in a scene, with translation, rotation and the solid's mesh
typedef struct {
	mesh_t* mesh;	///< mesh
	unsigned char rot_x;	///< angle of rotation X-axis
	unsigned char rot_y;	///< angle of rotation Y-axis
	unsigned char rot_z;	///< angle of rotation Z-axis
	int trans_x;	///< translation on X-axis
	int trans_y;	///< translation on Y-axis
	int trans_z;	///< translation on Z-axis
} object_t;

typedef struct {
	int x, y;
} Point_t;

typedef struct {
	int pitch, roll, yaw;
	int x, y, z;
} Cam_t;


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

extern int __LIB__  isin(unsigned int degrees) __z88dk_fastcall; /* input must be between 0 and 360 */
extern int __LIB__  icos(unsigned int degrees) __z88dk_fastcall; /* input must be between 0 and 360 */
extern int __LIB__  div256(long value); /* divide by 255 */


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




#endif /* __LIB3D_H__ */
