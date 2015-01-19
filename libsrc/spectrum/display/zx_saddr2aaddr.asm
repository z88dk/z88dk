; uchar __FASTCALL__ *zx_saddr2aaddr(void *pixeladdr)
; aralbrec 06.2007

PUBLIC zx_saddr2aaddr

.zx_saddr2aaddr

   ld a,h
   rra
   rra
   rra
   and $03
   or $58
   ld h,a
   
   ret
