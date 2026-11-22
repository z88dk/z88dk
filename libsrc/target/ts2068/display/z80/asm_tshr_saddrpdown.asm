; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrpdown(void *saddr)
;
; Modify screen address to move down one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrpdown
PUBLIC asm0_tshr_saddrpdown

EXTERN asm_zx_saddrpdown
EXTERN asm0_zx_saddrpdown

defc asm_tshr_saddrpdown = asm_zx_saddrpdown
defc asm0_tshr_saddrpdown = asm0_zx_saddrpdown
