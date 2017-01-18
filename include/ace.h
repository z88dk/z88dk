/*
 * Headerfile for Jupiter ACE specific stuff
 *
 * $Id: ace.h,v 1.1 2010-05-31 08:29:06 stefano Exp $
 */

#ifndef __ACE_H__
#define __ACE_H__

#include <sys/types.h>

/////////////
// CONSTANTS
/////////////

// Text attributes

#define INVERSE        0x80


///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

extern int  __LIB__ ace_freemem(void);


////////////
// TAPE I/O
////////////

struct acetapehdr {             // standard tape header
   unsigned char type;
   char          name[10];
   size_t        length;
   size_t        address;
   size_t        offset;
   char          name2[10];
};

extern int  __LIB__            tape_save(char *name, size_t loadstart,void *start, size_t len);
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type);
extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type);

extern int  __LIB__  tape_save_block_callee(void *addr, size_t len, unsigned char type);
extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type);

#define tape_save_block(a,b,c) tape_save_block_callee(a,b,c)
#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)



#endif
