
; void *im2_create_generic_isr_callee(uint8_t num_callback, void *address)

PUBLIC im2_create_generic_isr_callee

im2_create_generic_isr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr.asm"
