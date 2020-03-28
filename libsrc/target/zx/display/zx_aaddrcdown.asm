; uchar __FASTCALL__ *zx_aaddrcdown(void *attraddr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_aaddrcdown
PUBLIC _zx_aaddrcdown

.zx_aaddrcdown
._zx_aaddrcdown

; enter : hl = attribute address
; exit  : hl = new attribute address down one character
;         carry set if off screen

.attr_chardown

   ld a,l
   add a,$20
   ld l,a
   ret nc
   
   inc h
   ld a,$5a
   cp h
   ret
