
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)

XLIB sp1_MoveSprAbs
LIB SP1MoveSprAbs

.sp1_MoveSprAbs

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
   ex de,hl
   pop de
   jp SP1MoveSprAbs

; enter: IX = sprite structure address 
;        DE = animate bitdef displacement (0 for no animation) 
;         H = new row coord in chars 
;         L = new col coord in chars 
;         B = new horizontal rotation (0..7) ie horizontal pixel position 
;         C = new vertical rotation (0..7) ie vertical pixel position 
;        IY = clipping rectangle, absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
