
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_ClearRect(struct sp_Rect *r, uchar colour, uchar tile, uchar rflag)

XLIB sp1_ClearRect
LIB SP1ClearRect

.sp1_ClearRect

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
   jp SP1ClearRect

; enter :  d = row coord
;          e = col coord
;          b = width
;          c = height
;          h = attr
;          l = tile
;          a = bit 0 set for tiles, bit 1 set for tile colours, bit 2 set for sprites
