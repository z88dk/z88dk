/*
 *	A nice old stdarg.h
 *
 *	djm 28/2/2000
 *
 *	Will this work? Who knows!
 *
 *	NB. va_start must be called immediately after calling
 *	the function - i.e. no auto variables can be initialised
 *	(except to constants)
 *
 *	NB2. The first call to va_next returns with the value
 *	of the first named argument, the 2nd call returns the
 *	value of the 2nd named argument etc etc
 *
 *	I've only tested this with 2 byte arguments but it 
 *	seems to work...
 *
 *	$Id: stdarg.h,v 1.2 2001-04-20 16:04:24 dom Exp $
 */

#ifndef _STDARG_H
#define _STDARG_H

#ifndef DEF_GETARG
#define DEF_GETARG
extern int __LIB__ getarg(void);
#endif



#define va_list unsigned char *

#define va_start(ap,last) ap=(getarg()*2)+&last-2

#define va_arg(ap,type) (type *)*(ap-=sizeof(type))

#define va_end(ap)

/*
 * This (non-standard) macro could be used by routines
 * with a similar setup to the library printf routines
 */
#define va_addr(ap,type) (ap-=sizeof(type))


#endif /* _STDARG_H */

