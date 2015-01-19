; uint __FASTCALL__ zx_aaddr2py(void *attraddr)
; aralbrec 06.2007

PUBLIC zx_aaddr2py

.zx_aaddr2py

   ld a,l
   and $e0
   srl h
   rra
   srl h
   rra
   srl h
   rra
   
   ld l,a
   ld h,0
   ret
