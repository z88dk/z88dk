
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtol

EXTERN l0_strtol_callee

_strtol:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_strtol_callee
