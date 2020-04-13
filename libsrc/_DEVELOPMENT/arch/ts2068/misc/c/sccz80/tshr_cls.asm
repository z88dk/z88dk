; void tshr_cls(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls

EXTERN asm_tshr_cls

defc tshr_cls = asm_tshr_cls

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cls
defc _tshr_cls = tshr_cls
ENDIF

