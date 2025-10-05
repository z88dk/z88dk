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
 *	$Id: assert.h,v 1.5 2016-06-11 19:53:08 dom Exp $
 *
 */

#ifndef __ASSERT_H__
#define __ASSERT_H__

#include <stdio.h>
#include <stdlib.h>

#ifndef NDEBUG
#define __assert_s(s)       #s
#define __assert_i(s)       __assert_s(s)
#define assert(exp)         if (!(exp))  { fputs(__FILE__ " line " __assert_i(__LINE__) ": assert(" __assert_s(exp) ") failed\n", stderr); abort(); }
#else
#define assert(exp)
#endif /* NDEBUG */

#endif /* _ASSERT_H */

