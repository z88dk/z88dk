
; void im2_install_isr_callee(uint8_t vector, void *isr)

SECTION code_clib
SECTION code_z80

PUBLIC im2_install_isr_callee

EXTERN asm_im2_install_isr

im2_install_isr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_im2_install_isr
