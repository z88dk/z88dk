; uint __FASTCALL__ zx_aaddr2py(void *attraddr)
; Stefano, 2014.12

XLIB zx_aaddr2py
XREF HRG_LineStart

.zx_aaddr2py

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

   ld a,b
   rla
   rla
   rla
   and $f8
   ld l,a
   ld h,0
   ret
