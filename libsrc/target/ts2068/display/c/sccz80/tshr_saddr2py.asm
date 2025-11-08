; uchar tshr_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2py

EXTERN zx_saddr2py

defc tshr_saddr2py = zx_saddr2py

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddr2py
defc _tshr_saddr2py = tshr_saddr2py
ENDIF

