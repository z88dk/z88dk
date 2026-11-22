
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_saddr2cy(void *saddr)
;
; Character y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2cy

asm_zx_saddr2cy:

   ld a,l
   rlca
   rlca
   rlca
   xor h
   and $07
   xor h
   and $1f
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
