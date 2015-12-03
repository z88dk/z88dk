
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_saddr2cx(void *saddr)
;
; Character x coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2cx

asm_zx_saddr2cx:

   ld a,l
   and $1f
   
   ld l,a
   ld h,0
   
   ret
