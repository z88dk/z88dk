
; double strtod(const char *nptr, char **endptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtod

EXTERN l0_strtod_callee

_strtod:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_strtod_callee
