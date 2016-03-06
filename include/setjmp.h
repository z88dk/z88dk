/*
 *	setjmp.h
 *
 *	Routines for dealing with longjmps
 *
 *	$Id: setjmp.h,v 1.6 2016-03-06 21:38:22 dom Exp $
 */


#ifndef __SETJMP_H__
#define __SETJMP_H__

#include <sys/compiler.h>

/*
 * We have no register variables so we just need to
 * save sp and pc (and ix to cope with sdcc)
 */

typedef struct {
	int	ix
	int	sp;
	int	pc;
} jmp_buf;


extern int __LIB__ setjmp(jmp_buf env);
extern void __LIB__ longjmp(jmp_buf env, int val);

#endif /* _SETJMP_H */
