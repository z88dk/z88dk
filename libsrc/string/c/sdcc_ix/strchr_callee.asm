
; char *strchr_callee(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strchr_callee

EXTERN asm_strchr

_strchr_callee:

   pop af
   pop hl
   pop bc
   push af

   jp asm_strchr
