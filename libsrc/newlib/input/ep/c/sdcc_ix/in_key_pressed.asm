
; int in_key_pressed(uint16_t scancode)

SECTION code_clib
SECTION code_input

PUBLIC _in_key_pressed

EXTERN asm_in_key_pressed

_in_key_pressed:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_in_key_pressed
