
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC stpcpy

EXTERN asm_stpcpy

stpcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_stpcpy
