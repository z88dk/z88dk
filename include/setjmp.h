/*
 *	setjmp.h
 *
 *	Routines for dealing with longjmps
 *
 *	I've *never* used these functions in either 
 *	Small C or big C..I'd never consider doing it
 *	either!
 *
 *	$Id: setjmp.h,v 1.3 2001-10-16 18:30:32 dom Exp $
 */


#ifndef __SETJMP_H__
#define __SETJMP_H__

/*
 * We have no register variables so we just need to
 * save sp and pc
 */

typedef struct {
	int	sp;
	int	pc;
} jmp_buf;


extern int __LIB__ setjmp(jmp_buf env);
extern void __LIB__ longjmp(jmp_buf env, int val);

#endif /* _SETJMP_H */
