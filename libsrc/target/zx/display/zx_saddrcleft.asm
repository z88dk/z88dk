; uchar __FASTCALL__ *zx_saddrcleft(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrcleft
PUBLIC _zx_saddrcleft

.zx_saddrcleft
._zx_saddrcleft

; enter: hl = valid screen address
; exit : carry = moved off screen
;        hl = new screen address one character left with line wrap
; uses : af, hl

   ld a,l
   dec l
   or a
   ret nz
   
   ld a,h
   sub $08
   ld h,a
   cp $40

   ret
