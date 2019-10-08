
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcpy_callee

EXTERN asm_strcpy

strcpy_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_strcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcpy_callee
defc _strcpy_callee = strcpy_callee
ENDIF

