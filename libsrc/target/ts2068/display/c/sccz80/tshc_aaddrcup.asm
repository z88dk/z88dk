; void *tshc_aaddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrcup

EXTERN zx_saddrcup

defc tshc_aaddrcup = zx_saddrcup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrcup
defc _tshc_aaddrcup = tshc_aaddrcup
ENDIF

