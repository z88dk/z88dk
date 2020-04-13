; void *tshr_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrpup

EXTERN zx_saddrpup

defc tshr_saddrpup = zx_saddrpup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrpup
defc _tshr_saddrpup = tshr_saddrpup
ENDIF

