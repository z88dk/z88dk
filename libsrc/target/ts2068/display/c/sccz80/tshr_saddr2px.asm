; uint tshr_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2px

EXTERN asm_tshr_saddr2px

defc tshr_saddr2px = asm_tshr_saddr2px

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddr2px
defc _tshr_saddr2px = tshr_saddr2px
ENDIF

