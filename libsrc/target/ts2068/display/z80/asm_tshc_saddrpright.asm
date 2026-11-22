; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrpright(void *saddr, uint bitmask)
;
; Modify screen address and bitmask to move right one pixel.
; Indicate error if pixel is at the rightmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrpright

EXTERN asm_zx_saddrpright

defc asm_tshc_saddrpright = asm_zx_saddrpright
