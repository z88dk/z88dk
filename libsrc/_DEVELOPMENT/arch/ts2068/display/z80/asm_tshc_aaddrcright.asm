; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcright(void *aaddr)
;
; Modify attribute address to move right one character (eight pixels)
; If at rightmost edge move to leftmost column on next pixel row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcright

EXTERN asm_zx_saddrcright

defc asm_tshc_aaddrcright = asm_zx_saddrcright
