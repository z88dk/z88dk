; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_cyx2saddr(uchar row, uchar col)
;
; Screen address of top pixel row of character square at row, col.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cyx2saddr

EXTERN asm_zx_cyx2saddr

asm_tshr_cyx2saddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = screen address corresponding to the top
   ;              pixel row of the character square
   ;
   ; uses  : af, hl

   srl l
   jp nc, asm_zx_cyx2saddr
   
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
