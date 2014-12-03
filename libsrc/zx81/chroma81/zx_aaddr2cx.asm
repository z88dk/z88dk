; uint __FASTCALL__ zx_aaddr2cx(void *attraddr)
; Stefano, 2014.12

XLIB zx_aaddr2cx
XREF HRG_LineStart

.zx_aaddr2cx

   ld de,HRG_LineStart+2+32768
   and a
   sbc hl,de
   ld de,35
   and a
.sbloop
   sbc hl,de
   jr nc,sbloop
   adc hl,de

   ld a,l
   and $1f
   ld l,a
;   ld h,0
   
   ret
