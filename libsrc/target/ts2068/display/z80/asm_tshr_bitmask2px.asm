; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshr_bitmask2px(uchar bitmask)
;
; Return x coordinate 0-7 corresponding to bitmask.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_bitmask2px

EXTERN asm_zx_bitmask2px

defc asm_tshr_bitmask2px = asm_zx_bitmask2px
