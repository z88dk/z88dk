/* Control file for include relevent TIXX stuff */

/* $Id: ti.h,v 1.5 2010-09-19 00:24:08 dom Exp $ */

#ifndef __TICALC_H__
#define __TICALC_H__

#include <sys/compiler.h>
#include <sys/types.h>

#ifdef __TI82__
#include <ti/ti82.h>
#endif

#ifdef __TI83__
#include <ti/ti83.h>
#endif

#ifdef __TI8x__
#include <ti/ti8x.h>
#endif

#ifdef __TI83p__
#include <ti/ti8x.h>
#endif

#ifdef __TI85__
#include <ti/ti85.h>
#endif

#ifdef __TI86__
#include <ti/ti86.h>
#endif


/* Variable types */

#if defined __TI85__ || defined __TI86__

#define RealObj       0x00      /* Real number       */
#define CplxObj       0x01      /* Complex number    */
#define RealVect      0x02      /* Real Vector       */
#define CplxVect      0x03      /* Complex Vector    */
#define ListObj       0x04      /* List of Real Nums */
#define CListObj      0x05      /* List of Complex N */
#define MatObj        0x06      /* Matrix of Real N  */
#define CplxMatObj    0x07      /* Matrix of Cplx N  */
#define ConstObj      0x08      /* Constant Real     */
#define CConstObj     0x09      /* Constant Complex  */
#define EquObj        0x0A      /* Equation          */
#define RangeObj      0x0A      /* Range             */
#define StrngObj      0x0C      /* String            */
#define GDBObj        0x0D      /* Graph DB standard */
#define PolGDBObj     0x0E      /* Graph DB polar    */
#define PolGDBParm    0x0F      /* Graph DB parametric            */
#define PolGDBDiff    0x10      /* Graph DB differential equation */
#define PictObj       0x11      /* Picture           */
#define ProgObj       0x12      /* Program           */
#define ConvObj       0x13      /* Conversion/Range  */

#else

#define RealObj       0x00      /* Real number       */
#define ListObj       0x01      /* List              */
#define MatObj        0x02      /* Matrix            */
#define EquObj        0x03      /* Equation          */
#define StrngObj      0x04      /* String            */
#define ProgObj       0x05      /* Program           */
#define ProtProgObj   0x06      /* Protected program */
#define PictObj       0x07      /* Picture           */
#define GDBObj        0x08      /* Graph Database    */
#define NewEquObj     0x0B      /* New Equation      */
#define CplxObj       0x0C      /* Complex number    */
#define CListObj      0x0D	/* Complex list      */
#define AppVarObj     0x15	/* AppVar            */
#define TempProgObj   0x16	/* Temporary program */

#endif


struct TI_FILE {
	u16_t	first;		/* first byte in file  */
	long	size;		/* file size           */
	long	ptr;		/* current location    */
	u16_t	blsize;		/* block (single variable) size */
};


/* Find a variable */
extern long  __LIB__ ti_findvar (char objtype, char *filename);

/* Delete a variable (file) */
extern int  __LIB__ ti_removevar (char objtype, char *filename);

#endif
