; void __CALLEE__ sp1_MoveSprPix_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

PUBLIC sp1_MoveSprPix_callee
PUBLIC ASMDISP_SP1_MOVESPRPIX_CALLEE

EXTERN sp1_MoveSprAbs_callee
EXTERN ASMDISP_SP1_MOVESPRABS_CALLEE

EXTERN SP1V_TEMP_IY

.sp1_MoveSprPix_callee

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   ld (SP1V_TEMP_IY),ix
   pop ix
   push af
   
.asmentry

; Move sprite to an absolute pixel location.
;
; enter: ix = sprite structure address 
; (SP1V_TEMP_IY) = clipping rectangle, absolute coords and entirely on screen
;             (..+0) = row, (..+1) = col, (..+2) = width, (..+3) = height
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
