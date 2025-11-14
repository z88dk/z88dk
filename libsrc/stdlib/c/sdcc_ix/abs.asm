
; int abs(int j)

SECTION code_clib
SECTION code_stdlib

PUBLIC _abs

EXTERN asm_abs

_abs:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_abs
