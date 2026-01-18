#ifndef __ARCH_V1050_H__
#define __ARCH_V1050_H__

#include <sys/compiler.h>

//////////////////////////
//   Video interface
//////////////////////////

// Send a byte to the video section
extern void __LIB__ v1050_sendchar(int chr)  __z88dk_fastcall;

// Set the cursor shape
extern void __LIB__ set_cursor(void *shape)  __z88dk_fastcall;

#define CURS_HIDE     0  
#define CURS_GRAY     "\125\252\125\252\125\252\125\252\125\252\125\252"
#define CURS_BLOCK    "\377\377\377\377\377\377\377\377\377\377\377\377"


#endif
