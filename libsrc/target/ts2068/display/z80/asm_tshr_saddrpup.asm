; ===============================================================
; May 2107
; ===============================================================
;
; void *tshr_saddrpup(void *saddr)
;
; Modify screen address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrpup

EXTERN asm_zx_saddrpup

defc asm_tshr_saddrpup = asm_zx_saddrpup
