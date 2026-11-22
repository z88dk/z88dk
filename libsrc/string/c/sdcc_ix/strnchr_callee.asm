
; char *strnchr_callee(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strnchr_callee

EXTERN asm_strnchr

_strnchr_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_strnchr
