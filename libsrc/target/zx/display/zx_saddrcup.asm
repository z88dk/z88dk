; uchar __FASTCALL__ *zx_saddrcup(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrcup
PUBLIC _zx_saddrcup

.zx_saddrcup
._zx_saddrcup

; enter: hl = valid screen address
; exit : carry = moved off screen
;        hl = new screen address up one character
; uses : af, hl

   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   cp $40

   ret
