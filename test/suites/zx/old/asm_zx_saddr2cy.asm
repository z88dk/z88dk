
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

PUBLIC old_zx_saddr2cy

old_zx_saddr2cy:

   ld a,l
   rlca
   rlca
   rlca
   and $07
   ld l,a
   
   ld a,h
   and $18
   or l
   
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
