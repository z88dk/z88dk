
; void *im2_create_generic_isr_8080(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_create_generic_isr_8080

EXTERN l_im2_create_generic_isr_8080_callee

_im2_create_generic_isr_8080:

   pop hl
   dec sp
   pop af
   pop de

   push de
   push af
   inc sp
   push hl

   jp l_im2_create_generic_isr_8080_callee
