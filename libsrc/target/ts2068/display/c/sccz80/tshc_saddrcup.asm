; void *tshc_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcup

EXTERN zx_saddrcup

defc tshc_saddrcup = zx_saddrcup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrcup
defc _tshc_saddrcup = tshc_saddrcup
ENDIF

