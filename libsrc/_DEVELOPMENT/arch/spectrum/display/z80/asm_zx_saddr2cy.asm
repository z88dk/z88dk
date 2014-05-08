
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_saddr2cy(void *saddr)
;
; Character y coordinate corresponding to screen address.
;
; ===============================================================

PUBLIC asm_zx_saddr2cy

asm_zx_saddr2cy:

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
   ld h,0
   
   ret
