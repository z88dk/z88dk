
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _stpcpy

EXTERN asm_stpcpy

_stpcpy:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_stpcpy
