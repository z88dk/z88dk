; void __CALLEE__ sp1_MoveSprPix_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_MoveSprPix_callee
PUBLIC ASMDISP_SP1_MOVESPRPIX_CALLEE

EXTERN sp1_MoveSprAbs_callee
EXTERN ASMDISP_SP1_MOVESPRABS_CALLEE

.sp1_MoveSprPix_callee

   pop af
   pop bc
   pop de
   pop hl
   pop iy
   pop ix
   push af
   
.asmentry

; Move sprite to an absolute pixel location.
;
; enter: ix = sprite structure address 
;        iy = clipping rectangle, absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
;        de = pixel x coordinate (0..2047 is meaningful)
;        bc = pixel y coordinate (0..2047 is meaningful)
;        hl = next sprite frame (0 for no change) 
; uses : af, bc, de + SP1MoveSprAbs

.SP1MoveSprPix

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

   jp sp1_MoveSprAbs_callee + ASMDISP_SP1_MOVESPRABS_CALLEE

DEFC ASMDISP_SP1_MOVESPRPIX_CALLEE = # asmentry - sp1_MoveSprPix_callee
