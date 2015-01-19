; void __CALLEE__ sp1_MoveSprRel_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_MoveSprRel_callee
PUBLIC ASMDISP_SP1_MOVESPRREL_CALLEE

EXTERN sp1_MoveSprAbs_callee
EXTERN ASMDISP_SP1_MOVESPRABS_CALLEE

.sp1_MoveSprRel_callee

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop iy
   pop ix
   push af

.asmentry

; Move sprite a relative distance from current position.
;
; enter: ix = sprite structure address
;        hl = next sprite frame address (0 for no change)
;         d = relative row coord, signed byte
;         e = relative col coord, signed byte
;         b = relative horizontal pixel movement, signed byte
;         c = relative vertical pixel movement, signed byte
;        iy = clipping rectangle absolute coords and entirely on screen
;             (IY+0) = row, (IY+1) = col, (IY+2) = width, (IY+3) = height
; uses : af, bc, de + SP1MoveSprAbs

.SP1MoveSprRel

   ld a,(ix+5)           ; current horizontal rotation
   add a,b
   ld b,a
   sra a
   sra a
   sra a
   add a,e
   add a,(ix+1)
   ld e,a                ; e = absolute column position
   ld a,b
   cp $80
   jp c, mvpos1
   add a,8

.mvpos1

   and $07
   ld b,a                ; b = absolute horizontal rotation
   ld a,(ix+4)           ; current vertical rotation
   and $07               ; get rid of flag in bit 7
   add a,c
   ld c,a
   sra a
   sra a
   sra a
   add a,d
   add a,(ix+0)
   ld d,a                ; d = absolute row position
   ld a,c
   cp $80
   jp c, mvpos2
   add a,8

.mvpos2

   and $07
   ld c,a                ; c = absolute vertical rotation

   jp sp1_MoveSprAbs_callee + ASMDISP_SP1_MOVESPRABS_CALLEE

DEFC ASMDISP_SP1_MOVESPRREL_CALLEE = # asmentry - sp1_MoveSprRel_callee
