

SECTION code_fp_math32

PUBLIC sqr
EXTERN cm32_sccz80_fssqr

defc sqr = cm32_sccz80_fssqr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr
defc _sqr = sqr
ENDIF

