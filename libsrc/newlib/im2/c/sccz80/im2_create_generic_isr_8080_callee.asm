
; void *im2_create_generic_isr_8080_callee(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC im2_create_generic_isr_8080_callee, l0_im2_create_generic_isr_8080_callee

EXTERN asm_im2_create_generic_isr_8080

im2_create_generic_isr_8080_callee:

   pop hl
   pop de
   ex (sp),hl

l0_im2_create_generic_isr_8080_callee:

   ld a,l
   
   jp asm_im2_create_generic_isr_8080
