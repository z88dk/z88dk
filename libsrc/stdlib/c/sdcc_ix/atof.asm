
; float atof(const char *nptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atof

EXTERN _atof_fastcall

_atof:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _atof_fastcall
