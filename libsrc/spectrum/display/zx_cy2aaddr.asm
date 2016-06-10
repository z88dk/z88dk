; uchar __FASTCALL__ *zx_cy2aaddr(uchar row)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_cy2aaddr
PUBLIC _zx_cy2aaddr

.zx_cy2aaddr
._zx_cy2aaddr

   ld a,l
   rrca
   rrca
   rrca
   ld h,a
   
   and $e0
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret
