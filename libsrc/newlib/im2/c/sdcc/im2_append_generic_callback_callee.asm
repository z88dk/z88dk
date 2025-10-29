
; void im2_append_generic_callback_callee(uint8_t vector, void *callback)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_append_generic_callback_callee

EXTERN asm_im2_append_generic_callback

_im2_append_generic_callback_callee:

   pop af
   dec sp
   pop hl
   pop de
   push af

   ld l,h
   jp asm_im2_append_generic_callback
