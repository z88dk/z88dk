; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)
;
; Modify attribute address and mask to move left one pixel.
; Indicates error if pixel at leftmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpleft

EXTERN asm_zx_saddrpleft

defc asm_tshc_aaddrpleft = asm_zx_saddrpleft
