; uint __FASTCALL__ zx_aaddr2cx(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddr2cx
PUBLIC _zx_aaddr2cx
EXTERN HRG_LineStart

.zx_aaddr2cx
._zx_aaddr2cx

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

   ld a,l
   and $1f
   ld l,a
;   ld h,0
   
   ret
