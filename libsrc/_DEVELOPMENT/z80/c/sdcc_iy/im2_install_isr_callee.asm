
; void im2_install_isr_callee(uint8_t vector, void *isr)

SECTION code_z80

PUBLIC _im2_install_isr_callee

_im2_install_isr_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "z80/z80/asm_im2_install_isr.asm"
