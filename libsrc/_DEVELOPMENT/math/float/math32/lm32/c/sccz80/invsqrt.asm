

SECTION code_fp_math32

PUBLIC invsqrt
EXTERN cm32_sccz80_fsinvsqrt

defc invsqrt = cm32_sccz80_fsinvsqrt

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invsqrt
defc _invsqrt = invsqrt
ENDIF

