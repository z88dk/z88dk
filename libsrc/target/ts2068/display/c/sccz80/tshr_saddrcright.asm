; void *tshr_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcright

EXTERN asm_tshr_saddrcright

defc tshr_saddrcright = asm_tshr_saddrcright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrcright
defc _tshr_saddrcright = tshr_saddrcright
ENDIF

