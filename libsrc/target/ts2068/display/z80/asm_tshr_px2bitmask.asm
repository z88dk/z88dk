; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshr_px2bitmask(uchar x)
;
; Return bitmask corresponding to pixel x coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_px2bitmask

EXTERN asm_zx_px2bitmask

defc asm_tshr_px2bitmask = asm_zx_px2bitmask
