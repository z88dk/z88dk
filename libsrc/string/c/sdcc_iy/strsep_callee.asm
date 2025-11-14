
; char *strsep_callee(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC _strsep_callee

EXTERN asm_strsep

_strsep_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_strsep
