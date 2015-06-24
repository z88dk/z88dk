
; float atof(const char *nptr) __z88dk_fastcall

SECTION code_stdlib

PUBLIC _atof_fastcall

EXTERN mlib2d

_atof_fastcall:

   push ix
   
   call asm_atof
   
   pop ix
   
   jp mlib2d                   ; to sdcc_float

   INCLUDE "stdlib/z80/asm_atof.asm"
