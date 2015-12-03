
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcoll_callee

EXTERN asm_strcoll

strcoll_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strcoll
