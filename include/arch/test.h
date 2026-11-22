

#ifndef ARCH_TEST_H
#define ARCH_TEST_H

#include <sys/compiler.h>

#define REG_MMU0  0x50
#define REG_MMU1  0x51
#define REG_MMU2  0x52
#define REG_MMU3  0x53
#define REG_MMU4  0x54
#define REG_MMU5  0x55
#define REG_MMU6  0x56
#define REG_MMU7  0x57

// This function doesn't exist and is handled entirely by the preprocessor
// and peep hole optimiser
//
// The optimiser has rules for sdcc and sccz80, so we have to make the call to
// this resemble those used in newlib
//
// As a result, the sdcc variant needs to be __stdc so that the two parameters
// are packed into a single word.
#ifdef __SDCC
extern void ZXN_WRITE_REG(unsigned char reg,unsigned char data) __preserves_regs(a,d,e,iyl,iyh);
extern void ZXN_WRITE_REG_callee(unsigned char reg,unsigned char val) __z88dk_callee __preserves_regs(a,d,e,iyl,iyh);
#else
extern void __LIB__ ZXN_WRITE_REG(unsigned char reg,unsigned char data) __smallc;
extern void __LIB__ ZXN_WRITE_REG_callee(unsigned char reg,unsigned char val) __smallc  __z88dk_callee;
#endif
#define ZXN_WRITE_REG(a,b) ZXN_WRITE_REG_callee(a,b)

#ifdef __SDCC
#define ZXN_WRITE_MMU0(val)  { extern void ZXN_WRITE_MMU_0(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_0(val); }
#define ZXN_WRITE_MMU1(val)  { extern void ZXN_WRITE_MMU_1(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_1(val); }
#define ZXN_WRITE_MMU2(val)  { extern void ZXN_WRITE_MMU_2(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_2(val); }
#define ZXN_WRITE_MMU3(val)  { extern void ZXN_WRITE_MMU_3(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_3(val); }
#define ZXN_WRITE_MMU4(val)  { extern void ZXN_WRITE_MMU_4(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_4(val); }
#define ZXN_WRITE_MMU5(val)  { extern void ZXN_WRITE_MMU_5(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_5(val); }
#define ZXN_WRITE_MMU6(val)  { extern void ZXN_WRITE_MMU_6(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_6(val); }
#define ZXN_WRITE_MMU7(val)  { extern void ZXN_WRITE_MMU_7(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_7(val); }
#endif

#ifdef __SCCZ80
#define ZXN_WRITE_MMU0(val)  { extern void ZXN_WRITE_MMU_0(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_0(val); }
#define ZXN_WRITE_MMU1(val)  { extern void ZXN_WRITE_MMU_1(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_1(val); }
#define ZXN_WRITE_MMU2(val)  { extern void ZXN_WRITE_MMU_2(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_2(val); }
#define ZXN_WRITE_MMU3(val)  { extern void ZXN_WRITE_MMU_3(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_3(val); }
#define ZXN_WRITE_MMU4(val)  { extern void ZXN_WRITE_MMU_4(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_4(val); }
#define ZXN_WRITE_MMU5(val)  { extern void ZXN_WRITE_MMU_5(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_5(val); }
#define ZXN_WRITE_MMU6(val)  { extern void ZXN_WRITE_MMU_6(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_6(val); }
#define ZXN_WRITE_MMU7(val)  { extern void ZXN_WRITE_MMU_7(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_7(val); }
#endif



#endif

