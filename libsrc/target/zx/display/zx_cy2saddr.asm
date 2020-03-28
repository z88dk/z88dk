; uchar __FASTCALL__ *zx_cy2saddr(uchar row)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_cy2saddr
PUBLIC _zx_cy2saddr

; l = char Y 0..23

.zx_cy2saddr
._zx_cy2saddr

   ld a,l
   and $18
   or $40
   ld h,a
   
   ld a,l
   rrca
   rrca
   rrca
   and $e0
   ld l,a
   
   ret
