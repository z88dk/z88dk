
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat_callee

EXTERN asm_strcat

strcat_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_strcat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcat_callee
defc _strcat_callee = strcat_callee
ENDIF

