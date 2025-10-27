
; uint16_t in_pause(uint16_t dur_ms)

SECTION code_clib
SECTION code_input

PUBLIC _in_pause

EXTERN asm_in_pause

_in_pause:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_in_pause
