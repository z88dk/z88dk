
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC _strsep

EXTERN asm_strsep

_strsep:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_strsep
