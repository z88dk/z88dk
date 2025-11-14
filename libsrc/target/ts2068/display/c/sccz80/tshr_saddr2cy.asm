; uchar tshr_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2cy

EXTERN zx_saddr2cy

defc tshr_saddr2cy = zx_saddr2cy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddr2cy
defc _tshr_saddr2cy = tshr_saddr2cy
ENDIF

