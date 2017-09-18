
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat

EXTERN asm_strcat

strcat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcat
defc _strcat = strcat
ENDIF

