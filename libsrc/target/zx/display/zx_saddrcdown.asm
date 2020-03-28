; uchar __FASTCALL__ *zx_saddrcdown(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrcdown
PUBLIC _zx_saddrcdown

.zx_saddrcdown
._zx_saddrcdown

; enter: hl = valid screen address
; exit : carry = moved off screen
;        hl = new screen address one char down
; uses : af,hl

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
