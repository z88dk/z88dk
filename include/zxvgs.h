/* ZXVGS specific functions
   Created on 2002-01-21 by Yarek
030307	added #pragma output ZXVGS and #pragma -create-app
020128	added #ifndef; added bnkinfo and opensound

   $Id: zxvgs.h,v 1.3 2016-06-10 22:34:22 dom Exp $
*/

#ifndef _ZXVGS_H
#define _ZXVGS_H

#include <sys/compiler.h>

#pragma output ZXVGS

/* reading the joysticks */
extern int __LIB__ j0();
extern int __LIB__ j1();
extern int __LIB__ j2();
extern int __LIB__ j3();

/* sound devices */
extern int __LIB__ opensound(int device, int mode) __smallc;

/* memory banks */
extern int __LIB__ bnkfree();

/* direct loading and saving files */
extern int __LIB__ loadany(char *name, int adr, int len) __smallc;
extern int __LIB__ saveany(char *name, int adr, int len) __smallc;

#endif
