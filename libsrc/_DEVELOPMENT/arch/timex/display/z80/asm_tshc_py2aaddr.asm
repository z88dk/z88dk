; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_py2aaddr(uchar y)
;
; Attribute address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_py2aaddr

EXTERN asm0_zx_py2saddr

asm_tshc_py2aaddr:

   ld a,l
   and $07
   or $60

   jp asm0_zx_py2saddr
