
; double strtod(const char *nptr, char **endptr)

PUBLIC strtod

EXTERN asm_strtod

strtod:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strtod
