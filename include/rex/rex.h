/****************************************************************
 *		rex.h						*
 *			Header for Rex addin program.		*
 *								*
 ****************************************************************/


#ifndef _REX_H_
#define _REX_H_

#include <rex/message.h>
#include <rex/struct.h>
#include <rex/syscall.h>
#include <rex/syscallEx.h>
#include <rex/register.h>
#include <rex/Database.h>
#include <rex/CalendarDB.h>
#include <rex/TaskDB.h>
#include <rex/MemoDB.h>
#include <rex/StatusDB.h>
#include <rex/TextInfDB.h>


extern int __LIB__ DsPrintf(int, int, int, char*);

/*
* Graphic routines by Waleed Hasan
*/
extern int __LIB__ DsClearScreen(void);
extern int __LIB__ DsFillScreen(int);
extern int __LIB__ DsGetPixelAddr(int, int, unsigned char*);
extern int __LIB__ DsSetPixel(int, int);
extern int __LIB__ DsDisplayCircle(int, int, int);
extern int __LIB__ DsDisplayEllipse(int, int, int, int);

/*
* farcall functions
*/

extern unsigned long __LIB__ farcall();


#if !_NOFLOAT_
	extern double __LIB__ farcalld();
#endif

extern int __LIB__ findlib(unsigned char*);


extern int __LIB__ DsTrace(char*, ... );

#define DsDisplayBitmapDrawFar( arg1, arg2, arg3, arg4, arg5 ) syscall5( DS_DISPLAY_BITMAP_DRAW, arg1, arg2, arg3, arg4, arg5 )


#define FindLibrary( arg1 )			findlib( arg1 )

#endif /* _REX_H_ */
