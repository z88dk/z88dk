
; void in_mouse_amx_callee(uint8_t *buttons, uint16_t *x, uint16_t *y)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx_callee

EXTERN asm_in_mouse_amx

_in_mouse_amx_callee:

   call asm_in_mouse_amx
   
   exx
   pop bc
   exx
   
   pop hl
   ld (hl),a
   
   pop hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl
   ld (hl),c
   inc hl
   ld (hl),b
   
   exx
   push bc
   exx
   
   ret
