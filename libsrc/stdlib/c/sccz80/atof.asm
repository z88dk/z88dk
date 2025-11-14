
; double atof(const char *nptr)__smallc __z88dk_fastcall

SECTION code_clib
SECTION code_stdlib

PUBLIC atof

EXTERN mlib2d, asm_atof

.atof

    call asm_atof

    jp mlib2d                   ; to sccz80_float
