/* Runtime regression test for EVERY routine in the libsrc/l/llvmz80/ integer
 * runtime bridge.  The ravn/llvm-z80 backend emits compiler-rt helper names for
 * non-trivial integer multiply/divide/modulo; z88dk's ez80clang runtime does
 * NOT export them, so before libsrc/l/llvmz80/ existed any such program failed
 * to link with "undefined symbol: ___mulhi3".
 *
 * The harness (runtime_intdiv.sh) builds + runs this at -O2, -O3 and
 * -O2 --opt-code-size so
 * every bridge symbol is exercised (which names the backend emits is opt-level
 * and code-shape dependent):
 *
 *   16-bit  __mulhi3                       : always (volatile mul below)
 *           __divhi3 / __udivhi3 /
 *           __modhi3 / __umodhi3           : emitted at -O2 and --opt-code-size
 *           __divhi3_fast / __udivhi3_fast /
 *           __modhi3_fast / __umodhi3_fast : retained bridge aliases; current
 *                                            clang emits the plain names
 *   8-bit   __udivqi3 / __umodqi3          : emitted at --opt-code-size (inlined otherwise)
 *   32-bit  __divsi3 / __udivsi3 /
 *           __modsi3 / __umodsi3           : lone volatile div/mod blocks the
 *                                            div+rem fusion -> separate calls
 *           __divmodsi4 / __udivmodsi4     : a div AND mod of the same operands
 *                                            fuses into one call (ravn/llvm-z80
 *                                            #248); emitted at every opt level
 *
 * Values wrap the 16-bit multiply mod 2^16 (1234*57 = 70338 -> 4802),
 * exercising the low-16 __mulhi3 == __umulhi3 aliasing.
 */

extern int printf(const char *, ...);

/* Fused 32-bit divmod: quotient AND remainder of the SAME operands in one
 * function makes the backend fold the pair into __divmodsi4 / __udivmodsi4.
 * noinline keeps it a real runtime call (not folded into the caller). */
__attribute__((noinline)) long sfuse(long a, long b, long *r) { *r = a % b; return a / b; }
__attribute__((noinline)) unsigned long ufuse(unsigned long a, unsigned long b, unsigned long *r) { *r = a % b; return a / b; }

/* 8-bit unsigned div/mod -> __udivqi3 / __umodqi3 (backend calls these at --opt-code-size;
 * otherwise it inlines a DJNZ loop, so these names appear only at --opt-code-size). */
__attribute__((noinline)) unsigned char qdiv(unsigned char a, unsigned char b) { return a / b; }
__attribute__((noinline)) unsigned char qmod(unsigned char a, unsigned char b) { return a % b; }

int main(void)
{
	/* --- 16-bit + separate 32-bit: volatile blocks const-fold AND fusion --- */
	volatile int a = 1234, b = 57;
	volatile unsigned ua = 50000u, ub = 7u;
	volatile long la = 1000000L, lb = 7L;
	volatile unsigned long lua = 4000000000UL, lub = 13UL;

	printf("h %d %d %d %u %u %u\n",
	       (int)(a * b), (int)(a / b), (int)(a % b),
	       (unsigned)(ua * ub), (unsigned)(ua / ub), (unsigned)(ua % ub));
	printf("l %ld %ld %lu %lu\n",
	       (long)(la / lb), (long)(la % lb),
	       (unsigned long)(lua / lub), (unsigned long)(lua % lub));

	/* --- fused 32-bit divmod: __divmodsi4 / __udivmodsi4 --- */
	volatile long fa = 1000000L, fb = 7L;
	volatile unsigned long ufa = 4000000000UL, ufb = 13UL;
	long sr;
	long sq = sfuse(fa, fb, &sr);
	unsigned long ur;
	unsigned long uq = ufuse(ufa, ufb, &ur);
	printf("f %ld %ld %lu %lu\n", sq, sr, uq, ur);

	/* --- 8-bit unsigned: __udivqi3 / __umodqi3 --- */
	volatile unsigned char qa = 200, qb = 7;
	printf("q %u %u\n", (unsigned)qdiv(qa, qb), (unsigned)qmod(qa, qb));
	return 0;
}
