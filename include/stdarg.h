/*
 * stdarg with __smallc conventions is tricky. 
 *
 * Here's a exammple code of how to do it:
 * 
char *error(char *fmt, ...)
{
   va_list v;
   va_start(v, fmt);

#ifdef __SCCZ80
   vsnprintf(ebuf, sizeof(ebuf), va_ptr(v,char *), v);
#else
   vsnprintf(ebuf, sizeof(ebuf), fmt, v);
#endif

   return ebuf;
}
 */

#ifndef __STDARG_H__
#define __STDARG_H__

#include <sys/compiler.h>

#ifdef __Z88DK_R2L_CALLING_CONVENTION

/* sdcc/sccz80 in r2l mode is a lot more standard */
typedef unsigned char * va_list;

#define va_start(marker, last)  { marker = (va_list)&last + sizeof(last); }
#define va_arg(marker, type)    *((type *)((marker += sizeof(type)) - sizeof(type)))
#define va_copy(dest, src)      { dest = src; }
#define va_end(marker)          { marker = (va_list) 0; };

#define va_ptr(marker, type)    *((type *)(marker - sizeof(type)))

#else

/* sccz80 (l2r) variant*/
#ifndef DEF_GETARG
#define DEF_GETARG
extern int __LIB__ getarg(void);
#endif

typedef unsigned char * va_list;
#define va_start(ap,last)       ap=(getarg()*2)+(unsigned char *)&last-4
#define va_arg(ap,type)         (*(type*)(ap-=sizeof(type),ap))
#define va_copy(dst, src)       dst = src
#define va_end(ap)

#define va_ptr(ap,type)         (*(type*)(ap+2))


/*
 * This (non-standard) macro could be used by routines
 * with a similar setup to the library printf routines
 */
#define va_addr(ap,type) (ap-=sizeof(type))
#endif


#endif /* _STDARG_H */

