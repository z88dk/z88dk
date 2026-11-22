; void *tshc_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cy2saddr

EXTERN zx_cy2saddr

defc tshc_cy2saddr = zx_cy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cy2saddr
defc _tshc_cy2saddr = tshc_cy2saddr
ENDIF

