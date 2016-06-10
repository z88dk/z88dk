; uchar __FASTCALL__ *zx_py2saddr(uchar ycoord)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_py2saddr
PUBLIC _zx_py2saddr

.zx_py2saddr
._zx_py2saddr

   ld a,l
   and $07
   or $40
   ld h,a
   ld a,l
   rra
   rra
   rra
   and $18
   or h
   ld h,a
   
   ld a,l
   rla
   rla
   and $e0
   ld l,a
   
   ret
