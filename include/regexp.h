/*
 * Definitions etc. for regexp(3) routines.
 *
 * Caveat:  this is V8 regexp(3) [actually, a reimplementation thereof],
 * not the System V one.
 */
#ifndef __REGEXP_H
#define __REGEXP_H

#include <sys/compiler.h>

#define NSUBEXP  10

typedef struct regexp {
	char	*startp[NSUBEXP];
	char	*endp[NSUBEXP];
	char	regstart;	/* Internal use only. */
	char	reganch;	/* Internal use only. */
	char	*regmust;	/* Internal use only. */
	int	regmlen;	/* Internal use only. */
	char	program[1];	/* Unwarranted chumminess with compiler. */
} regexp;

#if defined(__LLVMZ80)
/* clang/llvmz80: like regexec below, regcomp/regerror are sccz80 __smallc
 * stack workers (pattern on the stack; regcomp returns its regexp* in HL).
 * Without __smallc clang uses its default sdcccall(1) -- passing the pattern
 * in HL and reading the return from DE -- so regcomp() returns a garbage
 * pointer and the very first regexec() then reports "corrupted program".
 * Declaring them __smallc (== sdcccall(0)) restores stack args + HL return.
 * See ravn/z88dk#39. */
extern regexp __LIB__ *regcomp(char *) __smallc;
extern void __LIB__ regerror(const char *) __smallc;
#else
extern regexp __LIB__ __SAVEFRAME__ *regcomp(char *);
extern void __LIB__ __SAVEFRAME__ regerror(const char *);
#endif

/* clang/llvmz80: regexec/regsub are sccz80 __smallc STACK workers in
 * libsrc/regex/cimpl/regexp.c which read args first-arg-DEEPEST (prog at [sp+8]).
 * Now that clang's __smallc maps to z80_smallc (left-to-right push), a plain
 * natural-order __smallc decl lands prog in the deepest slot, matching the
 * worker -- so clang shares the sccz80/sdcc branch below, no reversed-arg idiom.
 * regcomp/regerror above take one arg (order moot), still need __smallc for the
 * stack arg + HL return.  See ravn/z88dk#39, ravn/llvm-z80#279. */
#if !defined(__STDC_ABI_ONLY)
extern int __LIB__ __SAVEFRAME__ regexec(regexp *__prog, char *__string) __smallc;
extern void __LIB__ __SAVEFRAME__ regsub(regexp *__prog, char *__source, char *__dest) __smallc;
#else
__ZPROTO2(int,,regexec,regexp *,__prog, char *,__string)
__ZPROTO3(void,,regsub,regexp *,__prog, char *,__source, char *,__dest)
#endif

#endif
