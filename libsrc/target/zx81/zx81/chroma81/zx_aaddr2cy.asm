; uint __FASTCALL__ zx_aaddr2cy(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddr2cy
PUBLIC _zx_aaddr2cy
EXTERN HRG_LineStart

.zx_aaddr2cy
._zx_aaddr2cy

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

   ;   and $1f
   ld l,b
   ld h,0
   
   ret
