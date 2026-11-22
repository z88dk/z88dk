; void *tshc_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcdown

EXTERN zx_saddrcdown

defc tshc_saddrcdown = zx_saddrcdown

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrcdown
defc _tshc_saddrcdown = tshc_saddrcdown
ENDIF

