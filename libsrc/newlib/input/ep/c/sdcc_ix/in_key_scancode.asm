
; uint16_t in_key_scancode(int c)

SECTION code_clib
SECTION code_input

PUBLIC _in_key_scancode

EXTERN asm_in_key_scancode

_in_key_scancode:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_in_key_scancode
