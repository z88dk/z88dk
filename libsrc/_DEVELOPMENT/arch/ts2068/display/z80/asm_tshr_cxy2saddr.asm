; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_cxy2saddr(uchar x, uchar y)
;
; Screen address of top pixel row of character square at x,y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cxy2saddr

EXTERN asm_zx_cxy2saddr

asm_tshr_cxy2saddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = screen address corresponding to the top
   ;              pixel row of the character square
   ;
   ; uses  : af, hl

   srl l
   jp nc, asm_zx_cxy2saddr
   
   ld a,h
   rrca
   rrca
   rrca
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $18
   or $60
   ld h,a
   
   ret
