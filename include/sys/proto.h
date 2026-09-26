#ifndef __SYS_PROTO_H__
#define __SYS_PROTO_H__

// __ZPROTO{2,3,3N,4,5} declare a classic-clib worker that is compiled __smallc
// (left-to-right stack push, caller-cleanup).  For SCCZ80 and SDCC the natural
// declaration `extern r n(...) __smallc` is correct because their __smallc is
// left-to-right.  llvmz80/clang used to lack a left-to-right convention, so its
// branch declared a reversed-param REGISTER bridge (___n) plus a forwarding
// inline -- the source of the register-vs-stack ABI class (ravn/z88dk#22/#41).
// Now that clang's __smallc maps to __attribute__((z80_smallc)) (left-to-right,
// caller-cleanup -- ravn/llvm-z80#279), the llvmz80 branch is identical to the
// SDCC branch: a plain natural-order __smallc declaration of the public worker.

#if __SCCZ80
#define __ZPROTO2(r,p, n,t1,a1,t2,a2) extern r __LIB__ p n(t1 a1,t2 a2) __smallc;
#else
#define __ZPROTO2(r,p, n,t1,a1,t2,a2) extern r p n(t1 a1,t2 a2) __smallc;
#endif

#if __SCCZ80
#define __ZPROTO3(r,p, n,t1,a1,t2,a2,t3,a3) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3) __smallc;
#else
#define __ZPROTO3(r,p, n,t1,a1,t2,a2,t3,a3) extern r p n(t1 a1,t2 a2, t3 a3) __smallc;
#endif

// __ZPROTO3N: like __ZPROTO3 but passes args in NATURAL order (a1,a2,a3) to ___fn.
// For clang/llvmz80 this means: HL=a1, DE=a2, stack=a3 (bridge-caller-cleans a3).
// Use when the underlying asm function already wants HL=a1, DE=a2 -- the bridge
// only needs to pop a3 into BC (via IX frame), avoiding the full peek/swap dance.
// For sccz80/sdcc the behaviour is identical to __ZPROTO3 (all args on stack).
#if __SCCZ80
#define __ZPROTO3N(r,p, n,t1,a1,t2,a2,t3,a3) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3) __smallc;
#else
#define __ZPROTO3N(r,p, n,t1,a1,t2,a2,t3,a3) extern r p n(t1 a1,t2 a2, t3 a3) __smallc;
#endif

#if __SCCZ80
#define __ZPROTO4(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3,t4 a4) __smallc;
#else
#define __ZPROTO4(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4) extern r p n(t1 a1,t2 a2, t3 a3, t4 a4) __smallc;
#endif

#if __SCCZ80
#define __ZPROTO5(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4,t5,a5) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3,t4 a4,t5 a5) __smallc;
#else
#define __ZPROTO5(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4,t5,a5) extern r p n(t1 a1,t2 a2, t3 a3, t4 a4,t5 a5) __smallc;
#endif



#endif
