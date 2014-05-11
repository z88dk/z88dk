
; char *strsep(char ** restrict stringp, const char * restrict delim)

PUBLIC strsep

EXTERN asm_strsep

strsep:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_strsep
