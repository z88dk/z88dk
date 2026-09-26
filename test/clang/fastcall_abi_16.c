/* Regression test: clang's single 16-bit argument convention == z88dk_fastcall.
 *
 * z88dk marks many classic clib functions __z88dk_fastcall (single argument in
 * a fixed register).  For clang, sys/compiler.h leaves __z88dk_fastcall a no-op
 * because clang has no dedicated fastcall convention -- it relies on clang's
 * DEFAULT single-argument placement coinciding with z88dk_fastcall.  That
 * coincidence only holds for a 16-bit argument (HL == HL); it is FALSE for
 * 8-bit (clang A vs z88dk L) and 32-bit (clang HLDE vs z88dk DEHL).  See the
 * table in include/sys/compiler.h.
 *
 * This test pins the 16-bit contract: clang must place a single 16-bit argument
 * in HL.  If clang ever changes its i16 convention, this fails and the no-op
 * mapping of __z88dk_fastcall is no longer safe.
 *
 * Run via test/clang/fastcall_abi_16.sh (needs LLVMZ80EXE=<clang>).
 * Standalone -- pulls in no z88dk headers (avoids the _Float16 issue in
 * sys/types.h under a bare clang invocation).
 */

/* A single 16-bit argument -- the ONLY width where the fastcall no-op is safe. */
extern void sink16(unsigned int);

void call16(void)
{
	sink16(0x1234);
}
