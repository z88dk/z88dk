
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcoll_callee

EXTERN asm_strcoll

strcoll_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_strcoll

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcoll_callee
defc _strcoll_callee = strcoll_callee
ENDIF

