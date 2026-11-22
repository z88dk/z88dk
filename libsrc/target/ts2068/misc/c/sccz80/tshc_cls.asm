; void tshc_cls(uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls

EXTERN asm_tshc_cls

defc tshc_cls = asm_tshc_cls

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls
defc _tshc_cls = tshc_cls
ENDIF

