; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpright(void *aaddr, uchar bitmask)
;
; Modify attribute address and bitmask to move right one pixel.
; Indicate error if pixel is at the rightmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpright

EXTERN asm_zx_saddrpright

defc asm_tshc_aaddrpright = asm_zx_saddrpright
