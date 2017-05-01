
; void *im2_create_generic_isr(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC im2_create_generic_isr

EXTERN l0_im2_create_generic_isr_callee

im2_create_generic_isr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_im2_create_generic_isr_callee
