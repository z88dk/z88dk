/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.7 2006-04-08 07:54:17 aralbrec Exp $
 */

#ifndef __SPECTRUM_H__
#define __SPECTRUM_H__

#include <sys/types.h>

#ifdef PLUS3
/* If it's a +3 we want the dodos routine */
#pragma output NEEDplus3dodos
extern int __LIB__ findhand();
extern void __LIB__ freehand(int);
#endif

#ifdef RESIDOS
/* If it's residos then we want dodos routines */
#pragma output NEEDresidos
extern int __LIB__ findhand();
extern void __LIB__ freehand(int);
#endif

/* Tape handling routines */

/* Standard tape header */
struct zxtapehdr {
        unsigned char type;
        char    name[10];
        size_t length;
        size_t address;
        size_t offset;
};

extern int __LIB__ tape_save(char *name, size_t loadstart,void *start, size_t len);
extern int __LIB__ tape_save_block(void *addr, size_t len, unsigned char type);
extern int __LIB__ tape_load_block(void *addr, size_t len, unsigned char type);


/* Joystick Functions */

extern unsigned int __LIB__ in_JoyFuller(void);
extern unsigned int __LIB__ in_JoyKempston(void);
extern unsigned int __LIB__ in_JoySinclair1(void);
extern unsigned int __LIB__ in_JoySinclair2(void);
extern unsigned int __LIB__ in_JoyTimex1(void);
extern unsigned int __LIB__ in_JoyTimex2(void);

/* Mouse Functions */

/*
   AMX Mouse Variables - you must declare
   uint in_AMXcoordX, in_AMXcoordY, in_AMXdeltaX, in_AMXdeltaY;
*/

extern void __LIB__ in_MouseAMXInit(uchar xvector, uchar yvector);
extern void __LIB__ in_MouseAMXInit2(void);
extern void __LIB__ in_MouseAMX(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ in_MouseAMXSetPos(uint xcoord, uint ycoord);

/*
   Kempston Mouse Variables - you must declare
   uchar in_KempcoordX, in_KempcoordY, in_KemprawX, in_KemprawY;
*/

extern void __LIB__ in_MouseKempInit(void);
extern void __LIB__ in_MouseKemp(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ in_MouseKempSetPos(uint xcoord, uint ycoord);


#endif
