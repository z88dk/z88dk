
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
   pop hl
   jp SP1MoveSprAbs

; enter: ix = & struct sp1_ss 
;        hl = sprite frame address (0 = no change)
;         d = new row coord in chars 
;         e = new col coord in chars 
;         b = new horizontal rotation (0..7) ie horizontal pixel position 
;         c = new vertical rotation (0..7) ie vertical pixel position 
;        iy = clipping rectangle entirely on screen
;             (iy+0) = row, (iy+1) = col, (iy+2) = width, (iy+3) = height
