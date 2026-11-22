; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpdown(void *saddr)
;
; Modify attribute address to move down one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpdown
PUBLIC asm0_tshc_aaddrpdown

EXTERN asm_zx_saddrpdown
EXTERN asm0_zx_saddrpdown

defc asm_tshc_aaddrpdown = asm_zx_saddrpdown
defc asm0_tshc_aaddrpdown = asm0_zx_saddrpdown
