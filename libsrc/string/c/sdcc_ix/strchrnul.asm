
; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strchrnul

EXTERN asm_strchrnul

_strchrnul:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_strchrnul
