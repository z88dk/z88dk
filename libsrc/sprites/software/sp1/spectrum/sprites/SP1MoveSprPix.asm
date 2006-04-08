
; SP1MoveSprPix
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1MoveSprPix
LIB SP1MoveSprAbs

; Move sprite to an absolute pixel location.
;
; enter: ix = sprite structure address 
;        iy = clipping rectangle, absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
;        hl = pixel x coordinate (0..2047 is meaningful)
;        bc = pixel y coordinate (0..2047 is meaningful)
;        de = next sprite frame (0 for no change) 
; uses : af, bc, hl + SP1MoveSprAbs

.SP1MoveSprPix

   ld a,l
   and $07
   srl h                ; compute: hl = hl / 8, a = hl % 8
   rr l
   srl h
   rr l
   srl h
   rr l                 ; l = new col coord in chars
   ld h,b
   ld b,a               ; b = new horizontal rotation (0..7)

   ; hc = y coord

   ld a,c
   and $07
   srl h                ; compute: hc = hc / 8, a = hc % 8
   rr c
   srl h
   rr c
   srl h
   rr c
   ld h,c               ; h = new row coord in chars
   ld c,a               ; c = new vertical rotation (0..7)

   jp SP1MoveSprAbs
