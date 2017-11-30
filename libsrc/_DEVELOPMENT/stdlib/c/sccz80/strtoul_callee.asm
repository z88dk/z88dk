
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoul_callee

EXTERN asm_strtoul

strtoul_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_strtoul

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoul_callee
defc _strtoul_callee = strtoul_callee
ENDIF

