

SECTION code_fp_math32

PUBLIC inv
EXTERN cm32_sccz80_fsinv

defc inv = cm32_sccz80_fsinv

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv
defc _inv = inv
ENDIF

