; void *tshr_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrcdown

EXTERN zx_saddrcdown

defc tshr_saddrcdown = zx_saddrcdown

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrcdown
defc _tshr_saddrcdown = tshr_saddrcdown
ENDIF

