
; char *strrchr_callee(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strrchr_callee

EXTERN asm_strrchr

_strrchr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_strrchr
