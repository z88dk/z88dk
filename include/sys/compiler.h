

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__

/* Temporary fix to turn off features not supported by sdcc */
#ifdef Z88DK_USES_SDCC
#define __FASTCALL__
#define __CALLEE__
#define __LIB__
#define far
#endif

#endif
