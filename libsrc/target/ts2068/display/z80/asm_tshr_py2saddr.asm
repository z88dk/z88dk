; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_py2saddr(uchar y)
;
; Screen address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_py2saddr
PUBLIC asm0_tshr_py2saddr

EXTERN asm_zx_py2saddr
EXTERN asm0_zx_py2saddr

defc asm_tshr_py2saddr = asm_zx_py2saddr
defc asm0_tshr_py2saddr = asm0_zx_py2saddr
