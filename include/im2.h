#ifndef _IM2_H
#define _IM2_H

/*
 * IM2 Interrupt Library
 * 04.2004, 11.2006 aralbrec
 *
 * Interrupts should be disabled before calling any of these
 * functions and reenabled afterward.  Do this with some inline
 * assembler.
 *
 * The z80 allows the im2 vector table to be located anywhere
 * in memory starting on an exact 256-byte page.  This location
 * is specified to the library during the im2_Init() call which
 * sets the I register appropriately.  Other library functions
 * determine the location of the interrupt vector table directly
 * from the I register.
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
 * not do this without the help of some embedded assembler
 * (edit: described next).
 *
 * A light generic ISR is also provided.  It is identical
 * to the regular generic ISR but it only saves the main
 * register set AF,BC,DE,HL on interrupt.
 *
 * A normal C function can be registered with an existing
 * generic ISR to be run on interrupt.  To install a C
 * function directly so that it alone serves an interrupt
 * requires embedded assembler in the function to save
 * registers, restore them and reenable interrupts prior
 * to returning.  These additions can be made with the
 * help of the macros defined in this header.
 *
 * Example 1:
 *
 * BEGIN_ISR(myisr)
 * {
 *    // C code here
 * }
 * END_ISR
 *
 * Example 2:
 *
 * BEGIN_ISR_LIGHT(myisr)
 * {
 *    // C code here -- be careful as only af,bc,de,hl registers saved
 * }
 * END_ISR_LIGHT
 *
 * In both examples above the C function "void myisr(void)"
 * is created with code inserted to preserve and restore registers
 * as well as reenable interrupts and exit with the "reti" instruction.
 * The light version only saves the "af,bc,de,hl" registers whereas
 * the regular version saves all registers.  Care must be taken that
 * your C code does not cause other unsaved registers to be used while
 * using the light version.
 *
 * With this C isr created you can install it on an interrupt vector
 * to serve interrupts directly:
 *
 * im2_InstallISR(0, myisr);
 * 
 */

#ifndef _T_UCHAR
#define _T_UCHAR
   typedef unsigned char uchar;
#endif

#define BEGIN_ISR(name) void name(void) { asm("push\taf\npush\tbc\npush\tde\npush\thl\nex\taf,af\nexx\npush\taf\npush\tbc\npush\tde\npush\thl\npush\tix\npush\tiy\n");
#define END_ISR asm("pop\tiy\npop\tix\npop\thl\npop\tde\npop\tbc\npop\taf\nexx\nex\taf,af\npop\thl\npop\tde\npop\tbc\npop\taf\nei\nreti\n"); }

#define BEGIN_ISR_LIGHT(name) void name(void) { asm("push\taf\npush\tbc\npush\tde\npush\thl\n");
#define END_ISR_LIGHT(name) asm("pop\thl\npop\tde\npop\tbc\npop\taf\nei\nreti\n"); }

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

extern void __LIB__ im2_Init(uchar size, void *tableaddr, void *default_isr);

/*
 * size = size of interrupt vector table created minus 2 (minimum of 1)
 *        for 257 byte table, use 255
 *        for 256 byte table, use 254
 * tableaddr = 16-bit address of the interrupt vector table, LSB ignored
 *             and assumed to be zero.
 */

extern void __LIB__ *im2_InstallISR(uchar vector, void *isr);
extern void __LIB__ im2_EmptyISR(void);
extern void __LIB__ *im2_CreateGenericISR(uchar numhooks /* >=1 */, void *addr);
extern void __LIB__ *im2_CreateGenericISRLight(uchar numhooks /* >=1 */, void *addr);
extern void __LIB__ im2_RegHookFirst(uchar vector, void *hook);
extern void __LIB__ im2_RegHookLast(uchar vector, void *hook);
extern int  __LIB__ im2_RemoveHook(uchar vector, void *hook);

#endif
