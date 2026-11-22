
; char *strchrnul_callee(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strchrnul_callee

EXTERN asm_strchrnul

_strchrnul_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_strchrnul
