; uint __FASTCALL__ zx_aaddr2px(void *attraddr)
; Stefano, 2014.12

PUBLIC zx_aaddr2px
EXTERN HRG_LineStart

.zx_aaddr2px

   ld de,HRG_LineStart+2+32768
   and a
   sbc hl,de
   ld de,35
   and a
.sbloop
   sbc hl,de
   jr nc,sbloop
   adc hl,de
   ld  a,l
   rla
   rla
   rla
   and $f8
   ld l,a
   ld h,0
   
   ret
 