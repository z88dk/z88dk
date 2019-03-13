; uchar __FASTCALL__ *zx_aaddrcright(void *attraddr)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_aaddrcright
PUBLIC _zx_aaddrcright

.zx_aaddrcright
._zx_aaddrcright

   ; hl = valid attribute address
   ; hl = new attribute address right one character with line wrap
   ;      carry if off screen
   
   inc hl
   ld a,$5a
   cp h
   ret
