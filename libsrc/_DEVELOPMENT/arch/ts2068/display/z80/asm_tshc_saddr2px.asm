; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_saddr2px(void *saddr)
;
; Pixel x coordinate corresponding to the leftmost pixel at
; of the screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddr2px

EXTERN asm_zx_saddr2px

defc asm_tshc_saddr2px = asm_zx_saddr2px
