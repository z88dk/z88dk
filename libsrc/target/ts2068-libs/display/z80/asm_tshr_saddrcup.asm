; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrcup(void *saddr)
;
; Modify screen address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrcup

EXTERN asm_zx_saddrcup

defc asm_tshr_saddrcup = asm_zx_saddrcup
