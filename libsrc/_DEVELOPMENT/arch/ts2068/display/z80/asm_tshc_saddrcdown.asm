; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrcdown(void *saddr)
;
; Modify screen address to move down one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrcdown

EXTERN asm_zx_saddrcdown

defc asm_tshc_saddrcdown = asm_zx_saddrcdown
