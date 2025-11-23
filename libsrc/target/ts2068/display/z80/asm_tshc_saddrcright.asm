; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrcright(void *saddr)
;
; Modify screen address to move right one character (eight pixels)
; If at rightmost edge move to leftmost column on next pixel row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrcright

EXTERN asm_zx_saddrcright

defc asm_tshc_saddrcright = asm_zx_saddrcright
