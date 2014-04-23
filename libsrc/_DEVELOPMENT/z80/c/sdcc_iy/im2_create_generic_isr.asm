
; void *im2_create_generic_isr(uint8_t num_callback, void *address)

XDEF im2_create_generic_isr

im2_create_generic_isr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr.asm"

