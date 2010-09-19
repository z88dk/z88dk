/*
 *
 *      assert.h
 *
 *      Assertion - use liberally for debugging. Defining NDEBUG
 *      turns assertions off.
 *      assert(exp) where exp is non-zero does nothing, while
 *      assert(exp) where exp evaluates to zero aborts the program
 *      with a message like
 *
 *      Assertion failed: prog.c line 123: "exp"
 *
 *      djm 28/2/2000
 *
 *	$Id: assert.h,v 1.4 2010-09-19 00:24:08 dom Exp $
 *
 */

#ifndef __ASSERT_H__
#define __ASSERT_H__

#include <sys/compiler.h>

#ifndef NDEBUG
extern void __LIB__ l_assert(int, char *, char *);
#define assert(exp)     if((exp==0)) {l_assert(__LINE__, __FILE__, #exp );}
#else
#define assert(exp)
#endif /* NDEBUG */

#endif /* _ASSERT_H */

