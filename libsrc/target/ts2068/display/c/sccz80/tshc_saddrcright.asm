; void *tshc_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcright

EXTERN zx_saddrcright

defc tshc_saddrcright = zx_saddrcright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrcright
defc _tshc_saddrcright = tshc_saddrcright
ENDIF

