; uint __FASTCALL__ zx_saddr2cy(void *pixeladdr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddr2cy
PUBLIC _zx_saddr2cy

.zx_saddr2cy
._zx_saddr2cy

   ld a,l
   rlca
   rlca
   rlca
   and $07
   ld l,a
   ld a,h
   and $18
   or l
   ld l,a
   ld h,0
   
   ret
