; uint __FASTCALL__ zx_aaddr2px(void *attraddr)
; aralbrec 06.2007

PUBLIC zx_aaddr2px

.zx_aaddr2px

   ld a,l
   rla
   rla
   rla
   and $f8
   ld l,a
   ld h,0
   
   ret
 