
; long atol(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atol

EXTERN asm_atol

_atol:

   pop af
   pop hl

   push hl
   push af

   jp asm_atol
