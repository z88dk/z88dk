
; void im2_append_generic_callback_callee(uint8_t vector, void *callback)

SECTION code_clib
SECTION code_z80

PUBLIC im2_append_generic_callback_callee

EXTERN asm_im2_append_generic_callback

im2_append_generic_callback_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_im2_append_generic_callback
