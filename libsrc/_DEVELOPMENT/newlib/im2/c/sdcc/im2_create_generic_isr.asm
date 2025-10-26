
; void *im2_create_generic_isr(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_create_generic_isr

EXTERN _im2_create_generic_isr_callee

_im2_create_generic_isr:

   pop hl
   dec sp
   pop af
   pop de

   push de
   push af
   inc sp
   push hl

   jp _im2_create_generic_isr_callee
