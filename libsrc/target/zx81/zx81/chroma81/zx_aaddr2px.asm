; uint __FASTCALL__ zx_aaddr2px(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddr2px
PUBLIC _zx_aaddr2px
EXTERN HRG_LineStart

.zx_aaddr2px
._zx_aaddr2px

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
 
