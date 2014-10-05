
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION seg_code_stdlib

PUBLIC strtol_callee

strtol_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
