
#ifndef _Z80_H
#define _Z80_H

#include <stdint.h>

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern void       im2_init(void *im2_table_address);
extern void      *im2_install_isr(uint8_t vector, void (*isr)(void));
extern void      *im2_create_generic_isr(uint8_t num_callbacks, void *address);
extern void      *im2_create_generic_isr_light(uint8_t num_callbacks, void *address);
extern void       im2_append_generic_callback(uint8_t vector, void (*callback)(void));
extern void       im2_prepend_generic_callback(uint8_t vector, void (*callback)(void));
extern int        im2_remove_generic_callback(uint8_t vector, void (*callback)(void));

extern void       z80_delay_ms(uint16_t ms);
extern void       z80_delay_tstate(uint16_t tstates);
extern uint16_t   z80_get_int_state(void);
extern void       z80_set_int_state(uint16_t state);

#else

// SCCZ80

extern void       __LIB__ __FASTCALL__  im2_init(void *im2_table_address);
extern void       __LIB__              *im2_install_isr(uint8_t vector, void (*isr)(void));
extern void       __LIB__              *im2_create_generic_isr(uint8_t num_callbacks, void *address);
extern void       __LIB__              *im2_create_generic_isr_light(uint8_t num_callbacks, void *address);
extern void       __LIB__               im2_append_generic_callback(uint8_t vector, void (*callback)(void));
extern void       __LIB__               im2_prepend_generic_callback(uint8_t vector, void (*callback)(void));
extern int        __LIB__               im2_remove_generic_callback(uint8_t vector, void (*callback)(void));

extern void       __LIB__ __FASTCALL__  z80_delay_ms(uint16_t ms);
extern void       __LIB__ __FASTCALL__  z80_delay_tstate(uint16_t tstates);
extern uint16_t   __LIB__               z80_get_int_state(void);
extern void       __LIB__ __FASTCALL__  z80_set_int_state(uint16_t state);

// SCCZ80 CALLEE LINKAGE

extern void       __LIB__ __CALLEE__   *im2_install_isr_callee(uint8_t vector, void (*isr)(void));
extern void       __LIB__ __CALLEE__   *im2_create_generic_isr_callee(uint8_t num_callbacks, void *address);
extern void       __LIB__ __CALLEE__   *im2_create_generic_isr_light_callee(uint8_t num_callbacks, void *address);
extern void       __LIB__ __CALLEE__    im2_append_generic_callback_callee(uint8_t vector, void (*callback)(void));
extern void       __LIB__ __CALLEE__    im2_prepend_generic_callback_callee(uint8_t vector, void (*callback)(void));
extern int        __LIB__ __CALLEE__    im2_remove_generic_callback_callee(uint8_t vector, void (*callback)(void));

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define im2_install_isr(a,b)                im2_install_isr_callee(a,b)
#define im2_create_generic_isr(a,b)         im2_create_generic_isr_callee(a,b)
#define im2_create_generic_isr_light(a,b)   im2_create_generic_isr_light_callee(a,b)
#define im2_append_generic_callback(a,b)    im2_append_generic_callback_callee(a,b)
#define im2_prepend_generic_callback(a,b)   im2_prepend_generic_callback_callee(a,b)
#define im2_remove_generic_callback(a,b)    im2_remove_generic_callback_callee(a,b)

#endif

#endif
