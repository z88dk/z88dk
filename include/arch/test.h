

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

#ifndef __SDCC
extern void __LIB__ ZXN_WRITE_MMU0(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU1(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU2(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU3(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU4(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU5(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU6(unsigned char page) __smallc __z88dk_fastcall;
extern void __LIB__ ZXN_WRITE_MMU7(unsigned char page) __smallc __z88dk_fastcall;
#else
extern unsigned char ZXN_READ_MMU0(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU1(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU2(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU3(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU4(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU5(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU6(void) __preserves_regs(d,e,h,iyl,iyh);

extern unsigned char ZXN_READ_MMU7(void) __preserves_regs(d,e,h,iyl,iyh);


extern void ZXN_WRITE_MMU0(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU0_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU0(a) ZXN_WRITE_MMU0_fastcall(a)


extern void ZXN_WRITE_MMU1(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU1_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU1(a) ZXN_WRITE_MMU1_fastcall(a)


extern void ZXN_WRITE_MMU2(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU2_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU2(a) ZXN_WRITE_MMU2_fastcall(a)


extern void ZXN_WRITE_MMU3(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU3_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU3(a) ZXN_WRITE_MMU3_fastcall(a)


extern void ZXN_WRITE_MMU4(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU4_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU4(a) ZXN_WRITE_MMU4_fastcall(a)


extern void ZXN_WRITE_MMU5(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU5_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU5(a) ZXN_WRITE_MMU5_fastcall(a)


extern void ZXN_WRITE_MMU6(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU6_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU6(a) ZXN_WRITE_MMU6_fastcall(a)


extern void ZXN_WRITE_MMU7(unsigned char page) __preserves_regs(d,e,h,iyl,iyh);
extern void ZXN_WRITE_MMU7_fastcall(unsigned char page) __preserves_regs(d,e,h,iyl,iyh) __z88dk_fastcall;
#define ZXN_WRITE_MMU7(a) ZXN_WRITE_MMU7_fastcall(a)
#endif


#endif

