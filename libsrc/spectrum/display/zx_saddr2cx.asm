; uint __FASTCALL__ zx_saddr2cx(void *pixeladdr)
; aralbrec 06.2007

PUBLIC zx_saddr2cx

.zx_saddr2cx

   ld a,l
   and $1f
   ld l,a
   ld h,0
   
   ret
