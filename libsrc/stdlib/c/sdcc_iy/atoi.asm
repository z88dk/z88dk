
; int atoi(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atoi

EXTERN asm_atoi

_atoi:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_atoi
