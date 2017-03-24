/*
 * Definitions etc. for regexp(3) routines.
 *
 * Caveat:  this is V8 regexp(3) [actually, a reimplementation thereof],
 * not the System V one.
 */
#ifndef __REGEXP_H
#define __REGEXP_H

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
extern int __LIB__ __SAVEFRAME__ regexec(regexp *__prog, char *__string) __smallc;
extern void __LIB__ __SAVEFRAME__ regsub(regexp *__prog, char *__source, char *__dest) __smallc;
extern void __LIB__ __SAVEFRAME__ regerror(const char *);

#endif
