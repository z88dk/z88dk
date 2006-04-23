
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_MoveSprRel(struct sp1_ss *s, struct sp_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)

XLIB sp1_MoveSprRel
LIB SP1MoveSprRel

.sp1_MoveSprRel

   ld hl,15
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld ixl,e
   ld ixh,d
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld iyl,e
   ld iyh,d
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   dec hl
   ld d,(hl)
   dec hl
   dec hl
   ld e,(hl)
   dec hl
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ld b,(hl)
   pop hl
   jp SP1MoveSprRel

; enter: ix = sprite structure address
;        hl = next sprite frame address (0 for no change)
;         d = relative row coord, signed byte
;         e = relative col coord, signed byte
;         b = relative horizontal pixel movement, signed byte
;         c = relative vertical pixel movement, signed byte
;        iy = clipping rectangle absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
; uses : af, bc, hl + SP1MoveSprAbs
