#ifndef __OZ_H__
#define __OZ_H__

/* Control file for include OZ7xx stuff */

/* $Id: oz.h,v 1.6 2003-10-27 16:56:55 stefano Exp $ */

//#include <oz700/ozfont.h>
#include <oz700/ozgfx.h>
#include <oz700/ozinput.h>
#include <oz700/ozint.h>
#include <oz700/ozmisc.h>
#include <oz700/ozscreen.h>
#include <oz700/ozserial.h>
#include <oz700/oztime.h>
//#include <oz700/scaldate.h>


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
