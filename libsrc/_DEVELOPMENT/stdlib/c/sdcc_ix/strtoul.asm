
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoul

EXTERN l0_strtoul_callee

_strtoul:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_strtoul_callee
