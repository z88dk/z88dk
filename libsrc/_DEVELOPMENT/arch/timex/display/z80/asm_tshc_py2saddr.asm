; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_py2saddr(uchar y)
;
; Attribute address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_py2saddr

EXTERN asm_zx_py2saddr

defc asm_tshc_py2saddr = asm_zx_py2saddr
