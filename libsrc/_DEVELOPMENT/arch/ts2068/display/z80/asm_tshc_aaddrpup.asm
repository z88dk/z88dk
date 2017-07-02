; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpup(void *aaddr)
;
; Modify attribute address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpup

EXTERN asm_zx_saddrpup

defc asm_tshc_aaddrpup = asm_zx_saddrpup
