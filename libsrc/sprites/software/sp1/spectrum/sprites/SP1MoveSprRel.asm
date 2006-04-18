
; SP1MoveSprRel
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1MoveSprRel
LIB SP1MoveSprAbs

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

   jp SP1MoveSprAbs
