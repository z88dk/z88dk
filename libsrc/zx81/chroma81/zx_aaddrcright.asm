; uchar __FASTCALL__ *zx_aaddrcright(void *attraddr)
; Stefano, 2014.12

PUBLIC zx_aaddrcright
EXTERN HRG_LineStart

.zx_aaddrcright

   ; hl = valid attribute address
   ; hl = new attribute address right one character with line wrap
   ;         TODO: carry if off screen
   

   inc hl
;   ld a,$5a
;   cp h
   ret
