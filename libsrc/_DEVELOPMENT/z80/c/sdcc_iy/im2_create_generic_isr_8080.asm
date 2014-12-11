
; void *im2_create_generic_isr_8080(uint8_t num_callback, void *address)

SECTION code_z80

PUBLIC _im2_create_generic_isr_8080

_im2_create_generic_isr_8080:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,l
   
   INCLUDE "z80/z80/asm_im2_create_generic_isr_8080.asm"
