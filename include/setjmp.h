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

/*
 * l_setjmp/l_longjmp (libsrc/setjmp/c/l_setjmp.asm, l_longjmp.asm) use the
 * classic z88dk stack-based calling convention: the pointer argument is
 * popped off the stack (not read from a register) and the int return value
 * comes back in HL. That is exactly __smallc == sdcccall(0). Without this
 * attribute, llvmz80/clang uses its default sdcccall(1) convention (pointer
 * arg in HL register, 16-bit return read from DE) for both the argument
 * passing AND the return value, so l_setjmp appears to "return non-zero on
 * the direct call" (DE holds garbage, not the 0 the asm placed in HL) and
 * every setjmp/longjmp round-trip breaks (test/framework/test.c's
 * `if (setjmp(jmpbuf)==0)` dispatch always takes the else branch -> the
 * "(in setup)" failure seen across ~18 upstream test/suites). __smallc is a
 * no-op / native keyword for sccz80 and SDCC (they already use this
 * convention by default), so this is safe for all three compilers.
 *
 * ravn/llvm-z80#279: clang's __smallc now maps to z80_smallc (left-to-right).
 * l_setjmp takes one argument, so z80_smallc and sdcccall(0) coincide -- it
 * stays __smallc.  l_longjmp takes TWO arguments (env, val) and its clang
 * worker reads them in sdcccall(0) order (env nearest the return address);
 * z80_smallc would mirror that pair and swap env/val, so l_longjmp must pin
 * sdcccall(0) explicitly for clang.  sccz80/sdcc keep their native __smallc.
 */
extern int __LIB__ l_setjmp(jmp_buf *env) __smallc;
#if defined(__LLVMZ80)
extern int __LIB__ l_longjmp(jmp_buf *env, int val) __attribute__((sdcccall(0)));
#else
extern int __LIB__ l_longjmp(jmp_buf *env, int val) __smallc;
#endif

#endif /* _SETJMP_H */
