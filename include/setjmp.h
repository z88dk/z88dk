/*
 *	setjmp.h
 *
 *	Routines for dealing with longjmps
 *
 *	$Id: setjmp.h,v 1.7 2016-03-25 22:10:53 dom Exp $
 */


#ifndef __SETJMP_H__
#define __SETJMP_H__

#include <sys/compiler.h>

/*
 * We have no register variables so we just need to
 * save sp and pc (and ix to cope with sdcc)
 */

typedef struct {
	int	iy;
	int	ix;
	int	sp;
	int	pc;
} jmp_buf;

#define setjmp(env)         l_setjmp(&(env))
#define longjmp(env, val)   l_longjmp(&(env), val)

extern int __LIB__ l_setjmp(jmp_buf *env);
__ZPROTO2(void,,l_longjmp,jmp_buf *,env,int, val)

#endif /* _SETJMP_H */
