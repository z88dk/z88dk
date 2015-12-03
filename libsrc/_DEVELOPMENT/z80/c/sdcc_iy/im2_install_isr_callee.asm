
; void im2_install_isr_callee(uint8_t vector, void *isr)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_install_isr_callee

EXTERN asm_im2_install_isr

_im2_install_isr_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_im2_install_isr
