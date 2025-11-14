; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_MoveSprPix

EXTERN asm_sp1_MoveSprAbs

asm_sp1_MoveSprPix:

; Move sprite to an absolute pixel location.
;
; enter: ix = sprite structure address 
;        iy = clipping rectangle, absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
;        de = pixel x coordinate (0..2047 is meaningful)
;        bc = pixel y coordinate (0..2047 is meaningful)
;        hl = next sprite frame (0 for no change) 
; uses : af, bc, de + SP1MoveSprAbs

   ld a,e
   and $07
   srl d                ; compute: de = de / 8, a = de % 8
   rr e
   srl d
   rr e
   srl d
   rr e                 ; e = new col coord in chars
   ld d,b
   ld b,a               ; b = new horizontal rotation (0..7)

   ; dc = y coord

   ld a,c
   and $07
   srl d                ; compute: dc = dc / 8, a = dc % 8
   rr c
   srl d
   rr c
   srl d
   rr c
   ld d,c               ; d = new row coord in chars
   ld c,a               ; c = new vertical rotation (0..7)

   jp asm_sp1_MoveSprAbs
