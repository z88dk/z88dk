include(__link__.m4)

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__


/* Temporary fix to turn off features not supported by sdcc */
#if __SDCC | __clang__

// Wipe away all the sccz80 annotations
#define __LIB__
#define __SAVEFRAME__

// __SMALLC is for functions that are __smallc for sccz80 and __stdc for sdcc
#define __SMALLC 
#define far
#define __vasmallc
#define __stdc
#define __z88dk_deprecated
#define __z88dk_sdccdecl
#define __z88dk_saveframe

#define __Z88DK_R2L_CALLING_CONVENTION 1

#if __SDCC
// __smallconly is for functions that only come in a smallc variant
#define __smallconly __smallc
#else
// Clang - we're out of luck
#define __smallconly
#endif

// Make intellisense run easier..
#ifdef __clang__
#define __SMALLC
#define __smallc
#define __z88dk_callee
#define __z88dk_fastcall
#endif

#else
// This is for sccz80
#define __SMALLC __smallc
#define __smallconly __smallc
#define __vasmallc __smallc
#define __z88dk_deprecated
#endif

#ifdef __8080
#define __DISABLE_BUILTIN
#endif

#ifdef __8085
#define __DISABLE_BUILTIN
#endif

#if __SDCC && __GBZ80
#define __DISABLE_BUILTIN
#define __z88dk_fastcall
#endif

#define NONBANKED __nonbanked
#define BANKED __banked

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
