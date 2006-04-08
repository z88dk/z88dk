
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_MoveSprPix(struct sp1_ss *s, struct sp_Rect *clip, uchar *frame, uint x, uint y)

XLIB sp1_MoveSprPix
LIB SP1MoveSprPix

.sp1_MoveSprPix

   ld hl,11
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
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   push bc
   ld b,(hl)
   dec hl
   ld c,(hl)
   pop hl
   jp SP1MoveSprPix

; enter: ix = sprite structure address 
;        iy = clipping rectangle, absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
;        hl = pixel x coordinate (0..2047 is meaningful)
;        bc = pixel y coordinate (0..2047 is meaningful)
;        de = next sprite frame (0 for no change) 
; uses : af, bc, hl + SP1MoveSprAbs

