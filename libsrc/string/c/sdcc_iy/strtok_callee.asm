
; char *strtok_callee(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strtok_callee

EXTERN asm_strtok

_strtok_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strtok
