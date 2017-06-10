; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_aaddr2px(void *aaddr)
;
; Pixel x coordinate corresponding to the leftmost pixel
; of the attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddr2px

EXTERN asm_zx_saddr2px

defc asm_tshc_aaddr2px = asm_zx_saddr2px
