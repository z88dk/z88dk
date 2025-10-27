
; void *im2_create_generic_isr_8080_callee(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_create_generic_isr_8080_callee

EXTERN asm_im2_create_generic_isr_8080

_im2_create_generic_isr_8080_callee:

   pop hl
   dec sp
   pop af
   pop de
   push hl

   jp asm_im2_create_generic_isr_8080
