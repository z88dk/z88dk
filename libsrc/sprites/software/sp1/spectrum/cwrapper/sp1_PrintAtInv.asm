
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_PrintAtInv(uchar row, uchar col, uchar colour, uchar tile)

XLIB sp1_PrintAtInv
LIB SP1PrintAtInv

.sp1_PrintAtInv

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp SP1PrintAtInv

; enter : d = row coord
;         e = col coord
;         b = attr
;         c = tile
; uses  : af, bc, de, hl

