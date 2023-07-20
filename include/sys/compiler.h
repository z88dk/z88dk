

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__

#include <sys/proto.h>

#if defined(__CLION_IDE__) | defined(__INTELLISENSE__)

#define __LIB__
#define __SAVEFRAME__
#define __z88dk_fastcall
#define __FASTCALL__
#define __CALLEE__
#define __SCCZ80
#define __Z80
#define __naked
#define __z88dk_callee
#define __stdc
#define __smallc
#define __preserves_regs
#define __no_z88dk_declspec
#define __at(x)
#define __sfr
#define __vasmallc

#else

/* Temporary fix to turn off features not supported by sdcc */
#if __SDCC | __clang__
#define __LIB__
#define __SAVEFRAME__
#define far
#define __vasmallc
#define __Z88DK_R2L_CALLING_CONVENTION 1
#define __stdc
#define __z88dk_deprecated
#define __z88dk_sdccdecl

// Make intellisense run easier..
#if __clang__ | __CLANG
#define __STDC_ABI_ONLY
#define __smallc
#define __z88dk_callee
#define __z88dk_fastcall
#endif

#else
#define __vasmallc __smallc
#define __z88dk_deprecated
#endif

#endif

#ifdef __8080__
#define __DISABLE_BUILTIN
#endif

#ifdef __8085__
#define __DISABLE_BUILTIN
#endif

#if __SDCC && __GBZ80__
#define __DISABLE_BUILTIN
#define __z88dk_fastcall
#endif

#define NONBANKED __nonbanked
#define BANKED __banked

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
