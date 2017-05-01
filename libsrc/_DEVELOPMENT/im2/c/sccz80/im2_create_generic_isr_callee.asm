
; void *im2_create_generic_isr_callee(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC im2_create_generic_isr_callee, l0_im2_create_generic_isr_callee

EXTERN asm_im2_create_generic_isr

im2_create_generic_isr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_im2_create_generic_isr_callee:

   ld a,l
   
   jp asm_im2_create_generic_isr
