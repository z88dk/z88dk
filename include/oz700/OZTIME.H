/* 
	HTC Compatibility Library and OZ extras 
	4. TIME

	$Id: OZTIME.H,v 1.1 2003-10-14 08:36:19 stefano Exp $
*/

#ifndef _OZTIME_H
#define _OZTIME_H

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

extern unsigned __LIB__ ozsec(void);
extern unsigned __LIB__ ozmin(void);
extern unsigned __LIB__ ozhour(void);
extern unsigned __LIB__ ozweekday(void);
extern unsigned __LIB__ ozmonth(void);
extern unsigned __LIB__ ozday(void);
extern unsigned __LIB__ ozyear(void);
extern unsigned long __LIB__ oztime(void);

#endif
