; void *tshr_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cy2saddr

EXTERN zx_cy2saddr

defc tshr_cy2saddr = zx_cy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cy2saddr
defc _tshr_cy2saddr = tshr_cy2saddr
ENDIF

