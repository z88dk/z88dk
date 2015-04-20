
; void *im2_create_generic_isr_callee(uint8_t num_callback, void *address)

SECTION code_z80

PUBLIC _im2_create_generic_isr_callee, l0_im2_create_generic_isr_callee

_im2_create_generic_isr_callee:

   pop af
   pop hl
   pop de
   push af

l0_im2_create_generic_isr_callee:
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr.asm"

