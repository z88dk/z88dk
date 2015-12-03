
; uint16_t in_stick_keyboard(udk_t *u)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_keyboard

EXTERN asm_in_stick_keyboard

_in_stick_keyboard:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_in_stick_keyboard
