

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__

#include <sys/proto.h>

#if defined(__CLION_IDE__) | defined(__INTELLISENSE__)

#define __LIB__
#define __SMALLC
#define __SAVEFRAME__
#define __z88dk_fastcall
#define __FASTCALL__
#define __CALLEE__
#define __SCCZ80
#define __Z80
#define __naked
#define __z88dk_callee
#define __stdc
#define __smallc
#define __smallconly
#define __preserves_regs(x...)
#define __no_z88dk_declspec
#define __at(x)
#define __sfr
#define __vasmallc
#define __z88dk_callback

#else

/* Temporary fix to turn off features not supported by sdcc */
#if __SDCC | __clang__ | __XCC
#define __LIB__
#define __SAVEFRAME__
#define __SMALLC
#define far
#define __vasmallc
#define __Z88DK_R2L_CALLING_CONVENTION 1
#define __stdc
#define __z88dk_deprecated
#define __z88dk_sdccdecl

// __preserves_regs(...) is a builtin keyword in sccz80 and SDCC (it annotates
// which registers a hand-asm routine leaves untouched), but clang/ez80-clang
// have no such keyword.  Without a no-op mapping, ctype.h's fastcall decls
// (e.g. `isdigit_fastcall(int) __z88dk_fastcall CTYPE_PRESERVE`) fail to parse
// under clang once __STDC_ABI_ONLY is not defined ("expected function body
// after function declarator").  Map it to nothing for the clang toolchains.
#if __clang__ | __XCC
#define __preserves_regs(x...)
#endif

// __z88dk_callback marks a function that CLASSIC-LIBRARY code calls back into --
// a user callback reached through a library thunk, e.g. a qsort()/bsearch()
// comparator, or funopen()'s read/write/seek/close hooks.  The library invokes
// such callbacks with SDCC's DEFAULT calling convention: arguments pushed
// RIGHT-TO-LEFT (first argument nearest the return address), result returned in
// HL.  That is how the hand-written / SDCC-compiled comparator thunks in the
// classic clib (e.g. l_cmp_sdcc in classic/stdlib/_qsort.asm) pass the operands.
//
//   * sccz80 and sdcc: their OWN default already IS that convention, so the
//     macro is EMPTY -- a plain callback is already called correctly.
//   * llvmz80 / clang: clang's default is sdcccall(1) (arguments in registers),
//     which does NOT match, so the macro is overridden below to
//     __attribute__((sdcccall(0))) to pin the library's convention.
//
// It is deliberately NOT __smallc.  __smallc means z80_smallc (arguments pushed
// LEFT-TO-RIGHT) -- the MIRROR of sdcccall(0) for a multi-argument call -- so a
// __smallc comparator would receive its two operands swapped and INVERT the sort
// (verified at runtime: qsort produced a descending array).  It is also not the
// clang default (sdcccall(1), register args), which the thunk does not honour.
//
// Usage: put __z88dk_callback on the callback's definition AND on the matching
// function-pointer parameter type:
//     __z88dk_callback int cmp(const void *a, const void *b) { ... }
//     qsort(base, n, size, cmp);
// The single macro replaces a per-callback #ifdef and is empty for sccz80/sdcc,
// so the same source is portable across all three compilers.
// See ravn/llvm-z80#279, ravn/z88dk#41, ravn/z88dk#22.
#define __z88dk_callback

#if __SDCC
// __smallconly is for functions that only come in a smallc variant
#define __smallconly __smallc
#else
// Clang - we're out of luck
#define __smallconly
#endif

// Make intellisense run easier..
#if __clang__ | __CLANG | __XCC
#if !defined(__LLVMZ80)
#define __STDC_ABI_ONLY
#endif
// ravn/llvm-z80 clang honours SDCC calling conventions via the sdcccall
// attribute.  z88dk's classic clib functions are compiled __smallc (arguments
// pushed on the stack, caller cleans up) -- which is exactly sdcccall(0).
// Without this the attribute is a no-op and clang passes fixed arguments in
// HL, so e.g. putchar('H') -> the callee does `pop hl` and reads stack garbage
// (console output is corrupted).
//
// __z88dk_fastcall maps to the z88dk_fastcall attribute, which selects the
// ravn/llvm-z80 backend's z88dk-fastcall convention (CallingConv::
// Z80_Z88dkFastCall).  A single argument is passed in a fixed register by
// width, matching z88dk's classic clib (verified from source):
//   width | z88dk_fastcall (asm reads)      | z88dk_fastcall (backend)
//   ------+---------------------------------+---------------------------------
//   8-bit | L      (rs232_put.asm: `ld a,l`)| L      <- match
//   16-bit| HL     (swapendian.asm)         | HL     <- match
//   32-bit| DEHL                            | DE:HL  <- match (DE high, HL low)
// The return value uses the same registers.  Before z88dk_fastcall existed the
// macro was a no-op that only happened to work for a single 16-bit argument
// (clang's default i16 arg also lands in HL); 8/32-bit args were wrong.  Now
// all three widths are correct by construction.  The 16-bit contract remains
// pinned by a red-green regression test:
//   z88dk/test/clang/fastcall_abi_16.c
// and the full L/HL/DE:HL discipline by the LLVM lit test
//   llvm/test/CodeGen/Z80/z88dk-fastcall.ll (in the ravn/llvm-z80 tree).
// __z88dk_callee maps to the z88dk_callee attribute: arguments pushed on the
// stack like sdcccall(0), but the CALLEE cleans them up (CallingConv::
// Z80_Z88dkCallee).  This is the correct mapping -- z88dk clib functions marked
// __z88dk_callee callee-clean in their .asm, so the previous no-op was a latent
// bug (clang caller-cleaned while the callee also cleaned -> stack corruption).
// Backend mechanism pinned by llvm/test/CodeGen/Z80/z88dk-callee.ll; frontend
// mapping by clang/test/CodeGen/z80-callee.c.  End-to-end validation against a
// real clib link is Phase C.
// __smallc maps to the smallc attribute: arguments pushed LEFT-TO-RIGHT
// (last arg nearest the return address), CALLER cleans the stack -- byte-for-byte
// the SDCC/sccz80 __smallc layout (CallingConv::Z80_SmallC, ravn/llvm-z80#279).
// This is what the classic clib workers are compiled with, so a multi-arg
// __smallc declaration now calls them correctly with no reversed-param header
// bridge (fixes the register-vs-stack ABI class ravn/z88dk#22/#41).  Earlier this
// was wired to sdcccall(0) (right-to-left), which happened to work only for the
// 1-argument console workers where the two orders coincide.
#define __smallc __attribute__((smallc))
#define __z88dk_callee __attribute__((z88dk_callee))
#define __z88dk_fastcall __attribute__((z88dk_fastcall))

// ravn/z88dk#31: the variadic stdio family (printf/sprintf/scanf/...) returns
// its count in HL (the classic clib convention) and its varargs are pushed
// RIGHT-TO-LEFT so the fixed format arg is reachable.  That is exactly
// sdcccall(0), NOT __smallc -- now that __smallc means smallc (left-to-right)
// the two are no longer interchangeable, so __vasmallc must pin sdcccall(0)
// explicitly.  Guarded to __LLVMZ80: ez80-clang (__stdc, HL return) is already
// correct and must not be touched (it may not support sdcccall).
#if defined(__LLVMZ80)
#undef  __vasmallc
#define __vasmallc __attribute__((sdcccall(0)))
// See the __z88dk_callback doc above: clang's default is sdcccall(1), so pin the
// library callback convention (sdcccall(0)) explicitly.  Left EMPTY for
// ez80-clang/__XCC, whose default already matches and which may not support
// sdcccall.
#undef  __z88dk_callback
#define __z88dk_callback __attribute__((sdcccall(0)))
#endif
#endif

#else
// sccz80 case
#define __SMALLC __smallc
#define __smallconly __smallc
#define __vasmallc __smallc
#define __z88dk_deprecated
// __z88dk_callback: see the doc in the SDCC/clang branch above.  sccz80's own
// default calling convention already matches the classic-lib callback thunks,
// so it is empty (and, unlike __smallc, it is not a native sccz80 keyword).
#define __z88dk_callback
#endif

#endif

#ifdef __8080
#define __DISABLE_BUILTIN
#endif

#ifdef __8085
#define __DISABLE_BUILTIN
#endif

#if __SDCC && __GBZ80
#define __DISABLE_BUILTIN
#define __z88dk_fastcall
#endif

#define NONBANKED __nonbanked
#define BANKED __banked

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
