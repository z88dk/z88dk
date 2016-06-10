; uchar __FASTCALL__ *zx_saddrpup(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrpup
PUBLIC _zx_saddrpup

.zx_saddrpup
._zx_saddrpup

; enter: hl = valid screen address
; exit : carry = moved off screen
;        hl = new screen address one pixel up
; uses : af, hl

   ld a,h
   dec h
   and $07
   ret nz
   
   ld a,$08
   add a,h
   ld h,a
   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   
   cp $40
   ret
