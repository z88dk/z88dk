/****************************************************************
 *		WHmath.h					*
 *			Header for Rex addin program.		*
 *								*
 ****************************************************************/


#ifndef __WHmath__
#define __WHmath__


/*
* some constants for transcedental functions
*/
#define DPR     (57.295779513) /* degree per radian (180/pi) */
#define RPD     (0.0174532925) /* radians per degree (pi/180) */
#define HPR     (3.8197186342) /* hours per radian (12/pi) */

/*
* additional math functions by Waleed Hasan
*/
extern double __LIB__ xatan(double); /* helper functions */
extern double __LIB__ satan(double);
extern double __LIB__ sinus(double, int);

extern double __LIB__ WHsin(double);
extern double __LIB__ WHcos(double);
extern double __LIB__ WHtan(double);
extern double __LIB__ WHatan(double);
extern double __LIB__ WHatan2(double, double);


#endif /* __WHmath__ */
