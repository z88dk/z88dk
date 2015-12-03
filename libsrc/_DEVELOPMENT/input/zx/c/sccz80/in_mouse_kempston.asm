
; void in_mouse_kempston(uint8_t *buttons, uint16_t *x, uint16_t *y)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_kempston

EXTERN asm_in_mouse_kempston

in_mouse_kempston:

   call asm_in_mouse_kempston
   
   pop ix
   
   pop hl
   ld (hl),c
   inc hl
   ld (hl),b
   
   pop hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl
   ld (hl),a
   
   push hl
   push hl
   push hl
   
   jp (ix)
