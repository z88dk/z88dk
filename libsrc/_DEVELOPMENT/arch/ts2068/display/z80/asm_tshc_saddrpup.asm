; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrpup(void *saddr)
;
; Modify screen address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrpup

EXTERN asm_zx_saddrpup

defc asm_tshc_saddrpup = asm_zx_saddrpup
