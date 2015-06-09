
; double strtod(const char *nptr, char **endptr)

SECTION code_stdlib

PUBLIC strtod_callee

strtod_callee:

   pop hl
   pop de
   ex (sp),hl

   INCLUDE "stdlib/z80/asm_strtod.asm"
