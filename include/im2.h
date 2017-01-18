#ifndef _IM2_H
#define _IM2_H

/*
 * IM2 Interrupt Library
 * 04.2004, 11.2006, 02.2008 aralbrec
 *
 */
#include <sys/compiler.h>
#include <sys/types.h>

#define M_BEGIN_ISR(name) void name(void) { asm("push\taf\npush\tbc\npush\tde\npush\thl\nex\taf,af\nexx\npush\taf\npush\tbc\npush\tde\npush\thl\npush\tix\npush\tiy\n");
#define M_END_ISR asm("pop\tiy\npop\tix\npop\thl\npop\tde\npop\tbc\npop\taf\nexx\nex\taf,af\npop\thl\npop\tde\npop\tbc\npop\taf\nei\nreti\n"); }

#define M_BEGIN_ISR_LIGHT(name) void name(void) { asm("push\taf\npush\tbc\npush\tde\npush\thl\n");
#define M_END_ISR_LIGHT asm("pop\thl\npop\tde\npop\tbc\npop\taf\nei\nreti\n"); }

/*
 * In the following:
 *
 * void *isr            <=>    void (*isr)(void)
 * void *hook           <=>    void (*hook)(void) +++
 *
 * +++ if the carry flag is set at exit, succeeding hooks
 *     on a particular interrupt will not be executed.
 */

extern void __LIB__  im2_Init(void *tableaddr);

/*
 * tableaddr = 16-bit address of the interrupt vector table, LSB ignored
 *             and assumed to be zero.
 */

extern void __LIB__ *im2_InstallISR(uchar vector, void *isr) __smallc;
extern void __LIB__ im2_EmptyISR(void);
extern void __LIB__ *im2_CreateGenericISR(uchar numhooks /* >=1 */, void *addr) __smallc;
extern void __LIB__ *im2_CreateGenericISRLight(uchar numhooks /* >=1 */, void *addr) __smallc;
extern void __LIB__ im2_RegHookFirst(uchar vector, void *hook) __smallc;
extern void __LIB__ im2_RegHookLast(uchar vector, void *hook) __smallc;
extern int  __LIB__ im2_RemoveHook(uchar vector, void *hook) __smallc;

extern void __LIB__  *im2_InstallISR_callee(uchar vector, void *isr) __smallc __z88dk_callee;
extern void __LIB__  *im2_CreateGenericISR_callee(uchar numhooks, void *addr) __smallc __z88dk_callee;
extern void __LIB__  *im2_CreateGenericISRLight_callee(uchar numhooks, void *addr) __smallc __z88dk_callee;
extern void __LIB__   im2_RegHookFirst_callee(uchar vector, void *hook) __smallc __z88dk_callee;
extern void __LIB__   im2_RegHookLast_callee(uchar vector, void *hook) __smallc __z88dk_callee;
extern int  __LIB__   im2_RemoveHook_callee(uchar vector, void *hook) __smallc __z88dk_callee;

#define im2_InstallISR(a,b)             im2_InstallISR_callee(a,b)
#define im2_CreateGenericISR(a,b)       im2_CreateGenericISR_callee(a,b)
#define im2_CreateGenericISRLight(a,b)  im2_CreateGenericISRLight_callee(a,b)
#define im2_RegHooKFirst(a,b)           im2_RegHookFirst_callee(a,b)
#define im2_RegHookLast(a,b)            im2_RegHookLast_callee(a,b)
#define im2_RemoveHook(a,b)             im2_RemoveHook_callee(a,b)

#endif
