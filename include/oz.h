#ifndef __OZ_H__
#define __OZ_H__

/* Control file for include OZ7xx stuff */

/* $Id: oz.h,v 1.4 2003-10-22 13:55:48 stefano Exp $ */

//#include <oz700/ozfont.h>
#include <oz700/ozgfx.h>
#include <oz700/ozinput.h>
#include <oz700/ozint.h>
#include <oz700/ozmisc.h>
#include <oz700/ozscreen.h>
#include <oz700/ozserial.h>
#include <oz700/oztime.h>
//#include <oz700/scaldate.h>

#define ozgetch fgetc_cons
#define ozkeykit getk
#include <stdio.h>
#include <stdlib.h>

#endif