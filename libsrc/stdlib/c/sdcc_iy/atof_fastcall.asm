
; float atof(const char *nptr) __z88dk_fastcall

SECTION code_clib
SECTION code_stdlib

PUBLIC _atof_fastcall

EXTERN mlib2d, asm_atof

_atof_fastcall:
   
   call asm_atof
   
   jp mlib2d                   ; to sdcc_float
