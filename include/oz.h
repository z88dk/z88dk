#ifndef __OZ_H__
#define __OZ_H__

/* Control file for include OZ7xx stuff */

/* $Id: oz.h,v 1.2 2003-10-21 17:15:18 stefano Exp $ */

//#include <oz700/ozfont.h>
#include <oz700/ozgfx.h>
//#include <oz700/ozinput.h>
#include <oz700/ozscreen.h>
#include <oz700/oztime.h>
//#include <oz700/scaldate.h>
#include <oz700/ozmisc.h>

#define ozgetch fgetc_cons
#define ozkeykit getk
#include <stdio.h>

#endif