; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrcdown(void *saddr)
;
; Modify screen address to move down one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrcdown

EXTERN asm_zx_saddrcdown

defc asm_tshr_saddrcdown = asm_zx_saddrcdown
