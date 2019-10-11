
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcpy

EXTERN asm_strcpy

strcpy:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   
   jp asm_strcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcpy
defc _strcpy = strcpy
ENDIF

