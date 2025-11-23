; void *tshc_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpleft_callee

EXTERN zx_saddrpleft_callee

defc tshc_saddrpleft_callee = zx_saddrpleft_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrpleft_callee
defc _tshc_saddrpleft_callee = tshc_saddrpleft_callee
ENDIF

