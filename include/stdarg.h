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
 *	$Id: stdarg.h,v 1.4 2016-03-07 20:25:48 dom Exp $
 */

#ifndef __STDARG_H__
#define __STDARG_H__




#ifdef Z88DK_R2L_CALLING_CONVENTION

/* sdcc/sccz80 in r2l mode is a lot more standard */
typedef unsigned char * va_list;
#define va_start(marker, last)  { marker = (va_list)&last + sizeof(last); }
#define va_arg(marker, type)    *((type *)((marker += sizeof(type)) - sizeof(type)))
#define va_copy(dest, src)      { dest = src; }
#define va_end(marker)          { marker = (va_list) 0; };
#else

/* sccz80 (l2r) variant*/
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
#endif


#endif /* _STDARG_H */

