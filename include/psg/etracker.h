#ifndef __PSG_ETRACKER_H__
#define __PSG_ETRACKER_H__


#include <sys/compiler.h>

/* **************************************************
   etracker - tracker for SAA1099
   ************************************************** */


extern void __LIB__ saa_etracker_init(void *module);
extern void __LIB__ saa_etracker_play(void);


#endif
