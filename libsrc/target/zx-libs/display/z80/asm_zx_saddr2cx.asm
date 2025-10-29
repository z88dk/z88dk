
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_saddr2cx(void *saddr)
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

IF __SCCZ80
   ld h,0
ENDIF

   ret
