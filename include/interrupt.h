

#ifndef __INTERRUPT_H__
#define __INTERRUPT_H__

typedef void (*isr_t)(void);

// Initialise the interrupt subsystem if needed
extern int __LIB__ im1_init(void);
// Register an im1 ISR
extern int __LIB__ im1_install_isr(isr_t handler) ;
// Deregister an im1 ISR
extern int __LIB__ im1_uninstall_isr(isr_t handler) ;

// Initialise the NMI subsystem if required
extern int __LIB__ im1_init(void);
// Register an NMI ISR
extern int __LIB__ nmi_install_isr(isr_t handler) ;
// Deegister an NMI ISR
extern int __LIB__ nmi_uninstall_isr(isr_t handler) ;


// Simple timer tick handler
extern void __LIB__ tick_count_isr(void);
extern long __LIB__ tick_count;
#endif

