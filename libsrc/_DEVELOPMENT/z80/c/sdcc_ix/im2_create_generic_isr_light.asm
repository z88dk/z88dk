
; void *im2_create_generic_isr_light(uint8_t num_callback, void *address)

XDEF im2_create_generic_isr_light

im2_create_generic_isr_light:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr_light.asm"
