#ifndef __OZ_H__
#define __OZ_H__

/* Control file for include OZ7xx stuff */

/* $Id: oz.h,v 1.1 2003-10-14 08:36:19 stefano Exp $ */

//#include <oz700/OZFONT.H>
#include <oz700/OZGFX.H>
//#include <oz700/OZINPUT.H>
#include <oz700/OZSCREEN.H>
#include <oz700/OZTIME.H>
//#include <oz700/SCALDATE.H>

#define ozgetch fgetc_cons
#define ozkeykit getk
#include <stdio.h>

#endif