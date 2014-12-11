
; void *im2_create_generic_isr_8080_callee(uint8_t num_callback, void *address)

SECTION code_z80

PUBLIC im2_create_generic_isr_8080_callee

im2_create_generic_isr_8080_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr_8080.asm"
