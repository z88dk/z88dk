; void *tshc_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cxy2saddr

EXTERN zx_cxy2saddr

defc tshc_cxy2saddr = zx_cxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cxy2saddr
defc _tshc_cxy2saddr = tshc_cxy2saddr
ENDIF

