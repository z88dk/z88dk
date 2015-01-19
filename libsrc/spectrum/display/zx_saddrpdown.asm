; uchar __FASTCALL__ *zx_saddrpdown(void *pixeladdr)
; aralbrec 06.2007

PUBLIC zx_saddrpdown

.zx_saddrpdown

; enter: hl = valid screen address
; exit : carry = moved off screen
;        hl = new screen address one pixel down
; uses : af, hl

   inc h
   ld a,h
   and $07
   ret nz
   
   ld a,h
   sub $08
   ld h,a
   ld a,l
   add a,$20
   ld l,a
   ret nc
   
   ld a,h
   add a,$08
   ld h,a
   
   cp $58
   ccf
   ret
