/*
lib3d.h

Structs for standard Wizard 3d and 4d math functions

Copyright© 2002, Mark Hamilton

*/


#define PI 3.14159265358979


typedef struct {
	int x, y, z;
} Vector_t;

typedef struct {
	int x, y;
} Point_t;

typedef struct {
	int pitch, roll, yaw;
	int x, y, z;
} Cam_t;


/* protos */
extern __LIB__ ozrotatepointx(Vector_t *v, int rot);
extern __LIB__ ozrotatepointy(Vector_t *v, int rot);
extern __LIB__ ozrotatepointz(Vector_t *v, int rot);
extern __LIB__ ozplotpointcam(Vector_t *v, Cam_t *c, Point_t *p);
extern __LIB__ ozplotpoint(Vector_t *v, Point_t *p);
extern __LIB__ ozcopyvector(Vector_t *dest, Vector_t *src);
extern __LIB__ oztranslatevector(Vector_t *v, Vector_t *offset);


/*
	Integer sin functions taken from the lib3d library, OZ7xx DK
	by Hamilton, Green and Pruss
	isin and icos return a value from -16384 to +16384
*/

extern int __LIB__ isin(unsigned degrees); /* input must be between 0 and 360 */
extern int __LIB__ icos(unsigned degrees); /* input must be between 0 and 360 */
extern int __LIB__ div16384(long value); /* divide by 16384 */

