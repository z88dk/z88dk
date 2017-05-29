; ===============================================================
; May 2017
; ===============================================================
;
; uint tshr_saddr2cx(void *saddr)
;
; Character x coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddr2cx

asm_tshr_saddr2cx:

   ld a,h
   add a,a
   add a,a
   add a,a
   ld a,l
   adc a,a
   and $3f
   
   ld l,a
   ld h,0

   ret
