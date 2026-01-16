; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_px2bitmask(uchar x)
;
; Return bitmask corresponding to pixel x coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_px2bitmask

EXTERN asm_zx_px2bitmask

defc asm_tshc_px2bitmask = asm_zx_px2bitmask
