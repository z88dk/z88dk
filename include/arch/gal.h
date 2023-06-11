#ifndef __ARCH_GAL_H__
#define __ARCH_GAL_H__

// Add an interrupt handler on FRAME interrupt
#ifndef __INTERRUPT_H__
#define HAVE_ADD_RASTER_INT
extern void __LIB__ add_raster_int(void (*func)(void));
#endif


#endif
