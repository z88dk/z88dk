; void *tshr_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_py2saddr

EXTERN zx_py2saddr

defc tshr_py2saddr = zx_py2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_py2saddr
defc _tshr_py2saddr = tshr_py2saddr
ENDIF

