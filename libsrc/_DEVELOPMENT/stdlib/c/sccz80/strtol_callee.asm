
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtol_callee

EXTERN asm_strtol

strtol_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_strtol
