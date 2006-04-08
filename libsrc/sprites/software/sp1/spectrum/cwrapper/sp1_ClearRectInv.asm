
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_ClearRectInv(struct sp_Rect *r, uchar colour, uchar tile, uchar rflag)

XLIB sp1_ClearRectInv
LIB SP1ClearRectInv

.sp1_ClearRectInv

   ld hl,9
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   push de
   dec hl
   ld d,(hl)
   dec hl
   dec hl
   ld e,(hl)
   dec hl
   dec hl
   ld a,(hl)
   ex de,hl
   pop de
   jp SP1ClearRectInv

; enter :  d = row coord
;          e = col coord
;          b = width
;          c = height
;          h = attr
;          l = tile
;          a = bit 0 set for tiles, bit 1 set for tile colours, bit 2 set for sprites
; uses  : af, bc, de, hl, af', ix, iy
