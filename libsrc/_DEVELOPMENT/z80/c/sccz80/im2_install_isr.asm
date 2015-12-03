
; void im2_install_isr(uint8_t vector, void *isr)

SECTION code_clib
SECTION code_z80

PUBLIC im2_install_isr

EXTERN asm_im2_install_isr

im2_install_isr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_im2_install_isr
