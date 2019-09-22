
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcoll

EXTERN asm_strcoll

strcoll:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   
   jp asm_strcoll

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcoll
defc _strcoll = strcoll
ENDIF

