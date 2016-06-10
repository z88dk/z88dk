; uchar __FASTCALL__ *zx_saddr2aaddr(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddr2aaddr
PUBLIC _zx_saddr2aaddr

.zx_saddr2aaddr
._zx_saddr2aaddr

   ld a,h
   rra
   rra
   rra
   and $03
   or $58
   ld h,a
   
   ret
