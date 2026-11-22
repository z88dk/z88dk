; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrpleft(void *saddr, uchar bitmask)
;
; Modify screen address and mask to move left one pixel.
; Indicates error if pixel at leftmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrpleft

EXTERN asm_zx_saddrpleft

defc asm_tshc_saddrpleft = asm_zx_saddrpleft
