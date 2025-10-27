; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_MoveSprRel

EXTERN asm_sp1_MoveSprAbs

asm_sp1_MoveSprRel:

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

   jp asm_sp1_MoveSprAbs
