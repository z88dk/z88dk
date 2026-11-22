
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcoll

EXTERN asm_strcoll

_strcoll:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcoll
