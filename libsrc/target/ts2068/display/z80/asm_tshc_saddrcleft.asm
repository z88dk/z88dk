; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrcleft(void *saddr)
;
; Modify screen address to move left one character (eight pixels)
; If at the leftmost edge, move to rightmost column on prev row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrcleft

EXTERN asm_zx_saddrcleft

defc asm_tshc_saddrcleft = asm_zx_saddrcleft
