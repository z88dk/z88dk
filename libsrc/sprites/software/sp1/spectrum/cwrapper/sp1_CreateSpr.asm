
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; struct sp1_ss *sp1_CreateSpr(uchar type, uchar height, uchar *graphic, uchar plane)

XLIB sp1_CreateSpr
LIB SP1CreateSpr

.sp1_CreateSpr

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ex de,hl
   call SP1CreateSpr
   ld hl,0
   ret nc
   push ix
   pop hl
   ret

; enter :  b = height in chars
;          c = plane sprite occupies (0 = closest to viewer)
;          e = type (index into table), bit 7 = 1 for occluding, bit 6 = 1 for 2 byte definition
;         hl = graphic definition for column
; uses  : af, bc, de, hl, bc', de', hl', ix, iy
; exit  : no carry if memory allocation failed else ix = struct sp1_ss *

