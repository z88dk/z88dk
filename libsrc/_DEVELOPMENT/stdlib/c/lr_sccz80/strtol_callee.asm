
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

XDEF strtol_callee

strtol_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
