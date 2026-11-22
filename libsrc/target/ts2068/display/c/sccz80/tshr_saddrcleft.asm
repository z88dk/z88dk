; void *tshr_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcleft

EXTERN asm_tshr_saddrcleft

defc tshr_saddrcleft = asm_tshr_saddrcleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrcleft
defc _tshr_saddrcleft = tshr_saddrcleft
ENDIF

