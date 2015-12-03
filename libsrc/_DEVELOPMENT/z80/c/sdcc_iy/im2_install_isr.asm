
; void im2_install_isr(uint8_t vector, void *isr)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_install_isr

EXTERN asm_im2_install_isr

_im2_install_isr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_im2_install_isr
