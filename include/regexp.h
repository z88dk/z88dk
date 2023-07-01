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

extern regexp __LIB__ __SAVEFRAME__ *regcomp(char *);
extern void __LIB__ __SAVEFRAME__ regerror(const char *);

#ifndef __STDC_ABI_ONLY
extern int __LIB__ __SAVEFRAME__ regexec(regexp *__prog, char *__string) __smallc;
extern void __LIB__ __SAVEFRAME__ regsub(regexp *__prog, char *__source, char *__dest) __smallc;
#else
__ZPROTO2(int,,regexec,regexp *,__prog, char *,__string)
__ZPROTO3(void,,regsub,regexp *,__prog, char *,__source, char *,__dest)
#endif

#endif
