
; double strtod(const char *nptr, char **endptr) __z88dk_callee

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtod_callee, l0_strtod_callee

EXTERN mlib2d, asm_strtod

_strtod_callee:

   pop af
   pop hl
   pop de
   push af

l0_strtod_callee:
   
   call asm_strtod
   
   jp mlib2d                   ; to sdcc_float
