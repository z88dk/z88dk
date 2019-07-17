

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__


/* Temporary fix to turn off features not supported by sdcc */
#ifdef __SDCC
#define __LIB__
#define __SAVEFRAME__
#define far
#define __vasmallc
#define __Z88DK_R2L_CALLING_CONVENTION 1
#define __stdc
#define __z88dk_deprecated
#define __z88dk_sdccdecl
#else
#define __vasmallc __smallc
#define __z88dk_deprecated
#endif

#ifdef __8080__
#define __DISABLE_BUILTIN 
#endif

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
