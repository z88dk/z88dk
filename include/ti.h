#ifndef __TICALC_H__
#define __TICALC_H__

/* Control file for include relevent TIXX stuff */

/* $Id: ti.h,v 1.3 2005-03-30 10:38:31 stefano Exp $ */

#include <sys/types.h>

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


struct TI_FILE {
	u16_t	first;		/* first byte in file  */
	long	size;		/* file size           */
	long	ptr;		/* current location    */
	u16_t	blsize;		/* block (single variable) size */
};

/* Check if variable (file) exists */
extern int  __LIB__ check_var (char objtype, char *filename);

/* Delete a variable (file) */
extern int  __LIB__ remove_var (char objtype, char *filename);

#endif