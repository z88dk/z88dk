
; double strtod(const char *nptr, char **endptr) __smallc __z88dk_callee

SECTION code_clib
SECTION code_stdlib

PUBLIC strtod_callee

EXTERN mlib2d, asm_strtod

strtod_callee:

   pop hl
   pop de
   ex (sp),hl

   call asm_strtod

   jp mlib2d                   ; to sccz80_float

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtod_callee
defc _strtod_callee = strtod_callee
ENDIF

