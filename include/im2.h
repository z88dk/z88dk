#ifndef _IM2_H
#define _IM2_H

/*
 * IM2 Interrupt Library
 * 04.2004 aralbrec
 *
 * Interrupts should be disabled before calling any of these
 * functions and reenabled afterward.  Do this with some inline
 * assembler.
 *
 * The location of the im2 vector table is held in "_im2_vtable"
 * which is a 16 bit address that must begin on a 256-byte page
 * (the LSB will automatically be zeroed by the library).  Declare
 * its location with some inline assembler in your main.c file:
 *
 *    #asm
 *      DEFC _im2_vtable=$fe00
 *      XDEF _im2_vtable
 *    #endasm
 *
 * im2_Init initializes im2 mode and creates the default
 * im2 vector table.  The address of the default interrupt
 * service routine for all vectors is passed in as a parameter.
 * This can be im2_EmptyISR, which simply reenables interrupts
 * and returns, or something of your own choosing including
 * an absolute memory address.
 *
 * This library supplies a generic ISR that can register
 * any number of hooks on each interrupt vector.  A
 * generic ISR is created with a call to im2_CreateGenericISR,
 * which creates the ISR in RAM at an address of your
 * choosing.  You need to specify the maximum number of
 * hooks that will be registered with each generic ISR
 * you create.  RAM following each generic ISR will be reserved
 * to hold addresses of those hooks; the amount of RAM used
 * is (15 + 2*numhooks) bytes.
 *
 * After creating the generic ISR, register it on one or more
 * interrupt vectors with a call to im2_installISR.  The
 * generic ISR will save all registers and call its list of
 * registered hooks in order.  Those hooks are registered with
 * the im2_RegHook* functions and can be any C or assembly
 * function.  Remember, all registers are saved by the ISR
 * and your hooks do not have to be concerned with that.  Should
 * any hook return with the carry flag set, succeeding hooks
 * will not be run.  Make use of the special z88dk functions
 * return_c and return_nc to set the state of the carry flag
 * on exit from C.
 *
 * Your own ISRs can also be installed using im2_InstallISR.
 * These ISRs are like any raw machine code ISR -- they will
 * need to save and restore registers as well as reenable
 * interrupts prior to returning.  Straight C functions will
 * not do this without the help of some embedded assembler.
 *
 * A light generic ISR is also provided.  It is identical
 * to the regular generic ISR but it only saves the main
 * register set AF,BC,DE,HL on interrupt.
 *
 */

typedef unsigned char uchar;

/*
 * In the following:
 *
 * void *default_isr    <=>    void (*default_isr)(void)
 * void *isr            <=>    void (*isr)(void)
 * void *hook           <=>    void (*hook)(void) +++
 *
 * +++ if the carry flag is set at exit, succeeding hooks
 *     on a particular interrupt will not be executed.
 */

extern void __LIB__ im2_Init(uchar extended, void *default_isr);

/*
 * extended == 0 for a 256 byte im2 table otherwise a
 *             257 byte table appropriate for systems
 *             that could generate a 255 vector is
 *             created.
 */

extern void __LIB__ *im2_InstallISR(uchar vector, void *isr);
extern void __LIB__ im2_EmptyISR(void);
extern void __LIB__ *im2_CreateGenericISR(uchar numhooks /* >=1 */, void *addr);
extern void __LIB__ *im2_CreateGenericISRLight(uchar numhooks /* >=1 */, void *addr);
extern void __LIB__ im2_RegHookFirst(uchar vector, void *hook);
extern void __LIB__ im2_RegHookLast(uchar vector, void *hook);
extern int __LIB__ im2_RemoveHook(uchar vector, void *hook);

#endif
