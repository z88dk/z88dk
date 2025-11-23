
; long strtol_callee(const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtol_callee

EXTERN asm_strtol

_strtol_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_strtol
