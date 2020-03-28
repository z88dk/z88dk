; uint __FASTCALL__ zx_aaddr2py(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddr2py
PUBLIC _zx_aaddr2py
EXTERN HRG_LineStart

.zx_aaddr2py
._zx_aaddr2py

   ld b,-1
IF FORlambda
   ld hl,8319
ELSE
   ld hl,HRG_LineStart+2+32768
ENDIF
   and a
   sbc hl,de
IF FORlambda
   ld de,33
ELSE
   ld de,35
ENDIF
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
