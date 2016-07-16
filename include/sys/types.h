/* The <sys/types.h> header contains important data type definitions.
 * It is considered good programming practice to use these definitions, 
 * instead of the underlying base type.  By convention, all type names end 
 * with _t.
 *
 * $Id: types.h,v 1.6 2016-07-16 22:00:08 dom Exp $
 */

#ifndef __SYS_TYPES_H__
#define __SYS_TYPES_H__

#ifndef _FLOAT_T
#define _FLOAT_T
#ifdef Z88DK_USES_SDCC
typedef float float_t;
#else
typedef double float_t;
#endif
#endif

#ifndef _DOUBLE_T
#define _DOUBLE_T
#ifdef Z88DK_USES_SDCC
typedef float double_t;
#else
typedef double double_t;
#endif
#endif

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned int size_t;
#endif

#ifndef _SSIZE_T
#define _SSIZE_T
typedef signed int ssize_t;
#endif

#ifndef _CLOCK_T
#define _CLOCK_T
typedef unsigned long clock_t;
#endif

#ifndef _PID_T
#define _PID_T
typedef signed int pid_t;
#endif

#ifndef _BOOL_T
#define _BOOT_T
typedef unsigned char bool_t;
#endif

#ifndef _TIME_T
#define _TIME_T
typedef long time_t;
#endif

#ifndef _WILD_T
#define _WILD_T
typedef short wild_t;
#endif

#ifndef _FPOS_T
#define _FPOS_T
typedef unsigned long fpos_t;
#endif


typedef unsigned char   u8_t;      /* 8 bit type */
typedef unsigned short u16_t;      /* 16 bit type */
typedef unsigned long  u32_t;      /* 32 bit type */

typedef char            i8_t;      /* 8 bit signed type */
typedef short          i16_t;      /* 16 bit signed type */
typedef long           i32_t;      /* 32 bit signed type */

/* use of following is deprecated, a stopgap because some libraries use it */

#ifndef _T_UCHAR
#define _T_UCHAR
   typedef unsigned char uchar;    /* 8 bit unsigned char */
#endif

#ifndef _T_UINT
#define _T_UINT                    /* this is especially wrong, don't use */
   typedef unsigned int uint;      /* 16 bit unsigned int */
#endif

/* this makes converting MINIX sources a little bit easier */

#ifndef _PROTOTYPE
#define _PROTOTYPE(x,y) x y
#endif



#endif /* _TYPES_H */
