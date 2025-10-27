
; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strtok

EXTERN asm_strtok

_strtok:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strtok
