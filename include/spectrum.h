/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.5 2003-10-10 11:05:40 dom Exp $
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

/* Tape handling routines *

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


#endif


