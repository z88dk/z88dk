#ifndef __OZ_H__
#define __OZ_H__

#include <sys/compiler.h>

/* Control file for include OZ7xx stuff */

/* $Id: oz.h $ */

//#include <arch/oz700/ozfont.h>
#include <arch/oz700/ozgfx.h>
#include <arch/oz700/ozinput.h>
#include <arch/oz700/ozint.h>
#include <arch/oz700/ozmisc.h>
#include <arch/oz700/ozscreen.h>
#include <arch/oz700/ozserial.h>
#include <arch/oz700/oztime.h>
//#include <arch/oz700/scaldate.h>


/* functions renamed to have a double mode
   use the -DOZDK parameter to activate this */

#ifdef OZDK
#pragma set OZDK
#define ozgetch ozgetch2
#define ozkeyhit ozkeyhit2
#else
#define ozgetch fgetc_cons
#define ozkeyhit getk
#endif

#define getch ozgetch

#include <stdio.h>
#include <stdlib.h>

#endif
