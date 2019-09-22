
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp_callee

EXTERN asm_strcmp

strcmp_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_strcmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcmp_callee
defc _strcmp_callee = strcmp_callee
ENDIF

