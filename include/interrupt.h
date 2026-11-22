

#ifndef __INTERRUPT_H__
#define __INTERRUPT_H__

typedef void (*isr_t)(void);

// TODO: These should go away and be intrinsics
#define M_PRESERVE_INDEX __asm__("push\tiy\npush\tix\n")
#define M_RESTORE_INDEX __asm__("pop\tix\npop\tiy\n")

#define M_PRESERVE_MAIN __asm__("push\taf\npush\tbc\npush\tde\npush\thl\n")
#define M_RESTORE_MAIN __asm__("pop\thl\npop\tde\npop\tbc\npop\taf\n")

#define M_PRESERVE_ALL __asm__("push\taf\npush\tbc\npush\tde\npush\thl\nex\taf,af\nexx\npush\taf\npush\tbc\npush\tde\npush\thl\npush\tix\npush\tiy\n")
#define M_RESTORE_ALL __asm__("pop\tiy\npop\tix\npop\thl\npop\tde\npop\tbc\npop\taf\nexx\nex\taf,af\npop\thl\npop\tde\npop\tbc\npop\taf\n")

// Initialise the interrupt subsystem if needed
extern int __LIB__ im1_init(void);
// Register an im1 ISR
extern int __LIB__ im1_install_isr(isr_t handler) ;
// Deregister an im1 ISR
extern int __LIB__ im1_uninstall_isr(isr_t handler) ;

// Initialise the NMI subsystem if required
extern int __LIB__ nmi_init(void);
// Register an NMI ISR
extern int __LIB__ nmi_install_isr(isr_t handler) ;
// Deegister an NMI ISR
extern int __LIB__ nmi_uninstall_isr(isr_t handler) ;

// Register an ISR to run on frame sync - this is a portable shortcut 
extern void __LIB__ add_raster_int(isr_t handler);


// Simple timer tick handler
extern void __LIB__ tick_count_isr(void);
extern long __LIB__ tick_count;
#endif

