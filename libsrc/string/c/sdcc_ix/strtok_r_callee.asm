
; char *strtok_r_callee(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

PUBLIC _strtok_r_callee

EXTERN asm_strtok_r

_strtok_r_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_strtok_r
