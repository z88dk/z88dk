; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrpdown(void *saddr)
;
; Modify screen address to move down one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrpdown
PUBLIC asm0_tshc_saddrpdown

EXTERN asm_zx_saddrpdown
EXTERN asm0_zx_saddrpdown

defc asm_tshc_saddrpdown = asm_zx_saddrpdown
defc asm0_tshc_saddrpdown = asm0_zx_saddrpdown
