; uint __FASTCALL__ zx_aaddr2cy(void *attraddr)
; Stefano, 2014.12

PUBLIC zx_aaddr2cy
EXTERN HRG_LineStart

.zx_aaddr2cy

   ld b,-1
   ld de,HRG_LineStart+2+32768
   and a
   sbc hl,de
   ld de,35
   and a
.sbloop
   sbc hl,de
   inc b
   jr nc,sbloop

   ;   and $1f
   ld l,b
   ld h,0
   
   ret
