
; void *im2_create_generic_isr_callee(uint8_t num_callback, void *address)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_create_generic_isr_callee, l0_im2_create_generic_isr_callee

EXTERN asm_im2_create_generic_isr

_im2_create_generic_isr_callee:

   pop af
   pop hl
   pop de
   push af

l0_im2_create_generic_isr_callee:
   
   ld a,l
   
   jp asm_im2_create_generic_isr

