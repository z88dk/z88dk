
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC strsep_callee

EXTERN asm_strsep

strsep_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_strsep
