

SECTION code_fp_math32

PUBLIC sqrt
EXTERN cm32_sccz80_fssqrt

defc sqrt = cm32_sccz80_fssqrt

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt
defc _sqrt = sqrt
ENDIF

