
; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcasecmp_callee

EXTERN asm_strcasecmp

strcasecmp_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_strcasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcasecmp_callee
defc _strcasecmp_callee = strcasecmp_callee
ENDIF

