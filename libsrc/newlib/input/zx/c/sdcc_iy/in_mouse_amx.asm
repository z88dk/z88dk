
; void in_mouse_amx(uint8_t *buttons, uint16_t *x, uint16_t *y)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx

EXTERN asm_in_mouse_amx

_in_mouse_amx:

   call asm_in_mouse_amx

   pop ix
      
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
   
   push hl
   push hl
   push hl
   
   jp (ix)
