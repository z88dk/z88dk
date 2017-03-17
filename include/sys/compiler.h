

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__


/* Temporary fix to turn off features not supported by sdcc */
#ifdef Z88DK_USES_SDCC
#define __LIB__
#define __SAVEFRAME__
#define far
#define __vasmallc
#define Z88DK_R2L_CALLING_CONVENTION 1
#define __stdc
#else
#define __vasmallc __smallc
#endif

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
